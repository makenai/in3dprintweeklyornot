class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title
      t.string :url
      t.integer :cached_issue_id

      t.timestamps
    end
  end
end
