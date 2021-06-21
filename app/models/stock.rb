class Stock < ApplicationRecord
	has_many :top_sites

	def display_website
		website.to_s.gsub("https://", "").gsub("www.", "").split("/").first
	end	
end
