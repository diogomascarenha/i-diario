module Stepable
  extend ActiveSupport::Concern

  attr_accessor :step_id, :ignore_step, :ignore_date_validates

  included do
    validates_date :recorded_at
    validates :classroom_id, :recorded_at, :step_number, presence: true
    validates :step_id, presence: true, unless: :ignore_step
    validates :recorded_at, not_in_future: true, unless: :ignore_date_validates
    validates :recorded_at, posting_date: true, unless: :ignore_date_validates
    validate :recorded_at_is_in_selected_step
    validate :ensure_is_school_day, unless: :ignore_date_validates
  end

  module ClassMethods
    def by_step_number(step_number)
      where(step_number: step_number)
    end

    def by_recorded_at_between(start_at, end_at)
      where(arel_table[:recorded_at].gteq(start_at)).where(arel_table[:recorded_at].lteq(end_at))
    end

    def by_step_id(classroom, step_id)
      step = StepsFetcher.new(classroom).step_by_id(step_id)

      by_step_number(step.step_number)
    end
  end

  def steps_fetcher
    @steps_fetcher ||= StepsFetcher.new(classroom)
  end

  def step
    return steps_fetcher.step_by_id(step_id) if step_id.present?

    steps_fetcher.step(step_number)
  end

  def school_calendar
    @school_calendar ||= step.try(:school_calendar)
  end

  private

  def ensure_is_school_day
    return unless recorded_at.present? && school_calendar.present?
    return if school_calendar.school_day?(recorded_at, classroom.grade, classroom, nil)

    errors.add(:recorded_at, :not_school_term_day)
  end

  def recorded_at_is_in_selected_step
    return if step_id.blank? || recorded_at.blank?
    return if steps_fetcher.step_belongs_to_date?(step_id, recorded_at)

    errors.add(:recorded_at, :not_school_term_day)
  end
end
