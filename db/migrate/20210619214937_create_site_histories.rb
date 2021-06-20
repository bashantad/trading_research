class CreateSiteHistories < ActiveRecord::Migration[6.0]
  def change
    create_table :site_histories do |t|
      t.string :company_url
      t.belongs_to :top_site, foreign_key: true
      t.string :engagement_string
      t.string :country
      t.integer :country_rank
      t.integer :start_rank
      t.integer :end_rank
      t.float :daily_page_views
      t.float :daily_page_views_percentage
      t.float :daily_time_on_site
      t.float :daily_time_on_site_percentage
      t.float :bounce_rate
      t.float :bounce_rate_percentage
      t.timestamps
    end
  end
end
