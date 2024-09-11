class ChangeWorkTypeToIntegerInLiteraryWorks < ActiveRecord::Migration[7.1]
  def up
    change_column :literary_works, :work_type, :integer, using: 'work_type::integer', default: 9
  end

  def down
    change_column :literary_works, :work_type, :string
  end
end
