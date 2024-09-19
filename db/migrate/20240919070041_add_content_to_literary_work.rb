class AddContentToLiteraryWork < ActiveRecord::Migration[7.1]
  def change
    add_column :literary_works, :content, :text
  end
end
