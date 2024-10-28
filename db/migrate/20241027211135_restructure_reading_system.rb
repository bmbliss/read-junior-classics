class RestructureReadingSystem < ActiveRecord::Migration[7.2]
  def change
    # Remove program_enrollments table and its dependencies
    remove_foreign_key :reading_entries, :program_enrollments
    remove_column :reading_entries, :program_enrollment_id
    
    # Add direct connections to reading_entries
    add_reference :reading_entries, :child, foreign_key: true
    add_reference :reading_entries, :program, foreign_key: true, null: true
    
    # Drop the program_enrollments table
    drop_table :program_enrollments
  end
end
