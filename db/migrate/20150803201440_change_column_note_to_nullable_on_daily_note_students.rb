class ChangeColumnNoteToNullableOnDailyNoteStudents < ActiveRecord::Migration
  def change
    change_column :daily_note_students, :note, :decimal, precision: 7, scale: 3, null: true
  end
end
