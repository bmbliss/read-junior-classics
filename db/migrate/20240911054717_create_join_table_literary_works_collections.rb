class CreateJoinTableLiteraryWorksCollections < ActiveRecord::Migration[7.1]
  def change
    create_join_table :literary_works, :collections do |t|
      # t.index [:literary_work_id, :collection_id]
      # t.index [:collection_id, :literary_work_id]
    end
  end
end
