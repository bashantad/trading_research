class CreateTopSites < ActiveRecord::Migration[6.0]
  def change
    create_table :top_sites do |t|
      t.string :company_url
      t.integer :global_rank
      t.float :page_views_per_million
      t.float :page_views_per_user
      t.integer :country_rank
      t.float :reach_per_million
    
      t.timestamps
    end
  end
end
