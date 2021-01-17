class AddCompanyUrlToTraffics < ActiveRecord::Migration[6.0]
  def change
  	add_index :traffics, :company_url
  	add_index :traffics, [:company_url, :record_date], :unique => true  	
  end
end
