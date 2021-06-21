class ImportHistoryService
	def self.process_history(file_name)
		file_path = Rails.root.join("spec/controllers/histories/#{file_name}")
		File.open(file_path, "r") do |f|
		  f.each_line do |line|
		  	parsed = JSON.parse(line)
		  	company_url = parsed.delete("sitename")
		  	next if company_url.include?(".gov") || company_url.include?(".edu")
		  	top_site = TopSite.where(:company_url => company_url).first
		  	parsed["company_url"] = company_url
		  	parsed["top_site_id"] = top_site.id
		  	site_history = top_site.site_histories.new(parsed)
		  	site_history.save
		    puts "saved: #{site_history.id}: #{company_url}"
		  end
		end
	end

	def self.import_histories
		directory = Rails.root.join("spec/controllers/histories")
		Dir.entries(directory).each do |file_name|
			process_history(file_name)
		end
	end
end