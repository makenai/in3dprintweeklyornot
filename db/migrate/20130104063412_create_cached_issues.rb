class CreateCachedIssues < ActiveRecord::Migration
  def change
    create_table :cached_issues do |t|
      t.string :title
      t.string :url
      t.text :body

      t.timestamps
    end
  end
end
