class AddStockIdToTopSites < ActiveRecord::Migration[6.0]
  def change
    add_reference :top_sites, :stock, index: true
  end
end
