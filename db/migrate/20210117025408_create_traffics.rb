class CreateTraffics < ActiveRecord::Migration[6.0]
  def change
    create_table :traffics do |t|
      t.date :record_date
      t.float :page_views_per_million
      t.float :page_views_per_user
      t.integer :rank
      t.float :reach_per_million
      t.string :company_url

      t.timestamps
    end
  end
end
