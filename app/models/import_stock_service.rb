require 'csv'
class ImportStockService
	class << self
		def process_tech_stocks
			output = []
			names.each do |company_name|
				begin
					row = get_stock_csv_data(company_name)
					stock = save_stock(row, company_name)
					output << stock.website.to_s + " saved"
				rescue => e
					output << e.message
				end
			end
			output
		end

		private

		def names
			file_path =  get_full_path("tech_stock_names.csv")
			@names ||= CSV.read(file_path).flatten
		end

		def stocks
			return @stocks if defined?@data
			file_path = get_full_path("tech_stocks.csv")
			data = CSV.read(file_path)
			data.shift
			@stocks = data
		end

		def websites
			return @websites if defined?@websites
			file_name = "website_mapping.txt"
			file_path = get_full_path("#{file_name}")
			websites = {}
			File.open(file_path, "r") do |f|
			  f.each_line do |line|
			  	name, website = line.strip.gsub("{:name=>", "").split(", :website=>").collect {|a| a.gsub("}", "") }.collect {|a| JSON.parse(a) }
			  	websites[name] = website
			  end
			end
			@websites = websites
		end

		def get_full_path(file_name)
			Rails.root.join("spec/controllers/stocks/#{file_name}")
		end

		def get_company_name(index, name)
			company_name = names[index]
			raise "mismatched company name company_name: #{company_name}, name: #{name}" if name.include?(company_name) == false
			company_name
		end

		def get_website(company_name)
			websites[company_name]
		end	

		def get_stock_csv_data(name)
			stocks.detect { |stock| stock[1].include?(name) }
		end

		def save_stock(row, company_name)
			symbol, name, last_sale, net_change, percentage_change, market_cap, country, ipo_year, volume, sector, industry = row		
			return if Stock.exists?(name: company_name)
			record = {
				:ticker => symbol,
				:name => company_name,
				:website => get_website(company_name),
				:market_cap => market_cap,
				:country => country,
				:ipo_year => ipo_year,
				:sector => sector,
				:volume => volume,				
				:industry => industry,
			}
			stock = Stock.new(record)			
			stock.save
			stock	
		end
	end
end