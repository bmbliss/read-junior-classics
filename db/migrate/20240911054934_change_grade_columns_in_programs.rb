class ChangeGradeColumnsInPrograms < ActiveRecord::Migration[7.1]
  def change
    remove_column :programs, :min_grade, :integer
    remove_column :programs, :max_grade, :integer
    add_column :programs, :recommended_grade, :integer
  end
end
