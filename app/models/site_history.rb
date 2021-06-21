class SiteHistory < ApplicationRecord
	belongs_to :top_site

	def abs_percentage
		diff = (self.end_rank - self.start_rank).abs
		diff * 100/(start_rank * 1.0)
	end

	def self.process_history(file_name)
		file_path = Rails.root.join("spec/controllers/#{file_name}")
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
end
