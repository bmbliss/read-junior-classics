class AddUniqueIndexToProgramEnrollments < ActiveRecord::Migration[7.2]
  def change
    add_index :program_enrollments, [:child_id, :program_id], unique: true
  end
end
