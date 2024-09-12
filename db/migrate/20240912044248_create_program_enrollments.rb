class CreateProgramEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :program_enrollments do |t|
      t.references :child, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.timestamps
    end
  end
end
