class AdjustDuplicatedExemptedDisciplines < ActiveRecord::Migration
  def change
    student_enrollment_exempted_disciplines =
      StudentEnrollmentExemptedDiscipline.with_discarded
                                         .group(:student_enrollment_id, :discipline_id)
                                         .having('COUNT(1) > 1')
                                         .select(:student_enrollment_id, :discipline_id)
                                         .select('MAX(updated_at) AS updated_at')

    student_enrollment_exempted_disciplines.each do |student_enrollment_exempted_discipline|
      StudentEnrollmentExemptedDiscipline.with_discarded.by_discipline(
        student_enrollment_exempted_discipline.discipline_id
      ).by_student_enrollment(
        student_enrollment_exempted_discipline.student_enrollment_id
      ).where.not(
        updated_at: student_enrollment_exempted_discipline.updated_at
      ).destroy_all
    end
  end
end