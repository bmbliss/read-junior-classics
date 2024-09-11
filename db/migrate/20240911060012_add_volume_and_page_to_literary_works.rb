class AddVolumeAndPageToLiteraryWorks < ActiveRecord::Migration[7.1]
  def change
    add_column :literary_works, :volume, :integer
    add_column :literary_works, :page, :integer
  end
end
