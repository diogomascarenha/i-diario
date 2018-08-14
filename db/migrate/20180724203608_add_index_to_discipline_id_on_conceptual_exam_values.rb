class AddIndexToDisciplineIdOnConceptualExamValues < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    add_index :conceptual_exam_values, :discipline_id, algorithm: :concurrently, name: :idx_conceptual_exam_values_discipline_fk
  end
end
