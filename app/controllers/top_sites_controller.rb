class TopSitesController < ApplicationController
	def index
		stock_urls = Stock.all.collect(&:display_website).compact
		top_sites = TopSite.all.where(:company_url => stock_urls)
		@histories = SiteHistory.where("created_at > ?", 15.days.ago).where(:top_site_id => top_sites.collect(&:id)).sort do |a, b|
			a.abs_percentage <=> b.abs_percentage
		end.select { |a| a.start_rank > a.end_rank  && a.abs_percentage > 10 }.reverse
	end
end
