class CreateCheckToKeepUniqueDescriptiveExams < ActiveRecord::Migration
  def change
    execute <<-SQL
      ALTER TABLE descriptive_exams
      ADD CONSTRAINT check_descriptive_exam_is_unique
      CHECK (check_descriptive_exam_is_unique(id, classroom_id, discipline_id, recorded_at));
    SQL
  end
end
