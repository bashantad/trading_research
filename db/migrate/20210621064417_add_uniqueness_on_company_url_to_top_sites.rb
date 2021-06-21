class AddUniquenessOnCompanyUrlToTopSites < ActiveRecord::Migration[6.0]
  def change
    add_index :top_sites, [:company_url], :unique => true
  end
end
