class ImportHistoryService
	class << self
		def process_history(file_name)
			data = get_alexa_data(file_name)
			data.each do |parsed|
			  	top_site = TopSite.where(:company_url => parsed["company_url"]).first
			  	if top_site.blank?
			  		puts "site not imported #{parsed["company_url"]}"
			  	else
				  	parsed["top_site_id"] = top_site.id
				  	site_history = top_site.site_histories.new(parsed)
				  	site_history.save
				    puts "saved: #{site_history.id}: #{top_site.company_url}"
				end
			end			
		end

		def get_alexa_data(file_name)
			return @data if defined?@data
			file_path = Rails.root.join("spec/controllers/#{file_name}")
			data = []
			File.open(file_path, "r") do |f|
			  f.each_line do |line|
			  	begin
				  	parsed = JSON.parse(line)
				  	company_url = parsed.delete("sitename")
				  	next if company_url.include?(".gov") || company_url.include?(".edu")
				  	parsed["company_url"] = company_url		  	
				  	data << parsed
				rescue 
					puts "issue parsing #{line}"
				end
			  end
			end
			@data = data
		end

		def import_histories
			directory = Rails.root.join("spec/controllers/histories")
			Dir.entries(directory).each do |file_name|
				process_history(file_name)
			end
		end

		def import_top_sites
			data = get_alexa_data("new_stocks.txt")
			data.each do |row|
				data = {
					"company_url"=> row["company_url"],
					"global_rank"=> row["end_rank"],
					"country_rank"=> row["country_rank"],					
				}
				puts row["company_url"]
				# stock = Stock.where("company_url LIKE %#{row['company_url']}%").first
				# if stock.blank?
				# 	output << "stock not found for #{row["company_url"]}"
				# else
					top_site = TopSite.new(data)
					top_site.save(:validate => false)
				# end
			end
		end


		def link_stock_and_top_sites
			#TODO
		end
	end
end