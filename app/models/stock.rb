class Stock < ApplicationRecord
	has_many :top_sites

	def display_website
		website.to_s.gsub("https://", "").gsub("www.", "").split("/").first
	end

	def self.link_top_site
		Stock.all.map do |stock|
			if stock.display_website.present?
				corresponding_site = TopSite.where(:company_url => stock.display_website).first
				if corresponding_site.present?
					corresponding_site.update(:stock_id => stock.id)
				end
			end
		end
	end
end
