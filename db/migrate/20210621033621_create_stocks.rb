class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :ticker, :unique => true
      t.string :name
      t.string :website
      t.float :market_cap
      t.string :country
      t.string :ipo_year
      t.string :sector
      t.integer :volume      
      t.string :industry      

      t.timestamps
    end
  end
end
