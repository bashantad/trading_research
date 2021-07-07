class TopSitesController < ApplicationController
	def index
		stock_urls = Stock.all.collect(&:display_website).compact
		top_sites = TopSite.all.where(:company_url => stock_urls)
		@histories = SiteHistory.where(:top_site_id => top_sites.collect(&:id)).sort do |a, b|
			a.abs_percentage <=> b.abs_percentage
		end.select { |a| a.end_rank < a.start_rank  && a.abs_percentage > 20 && a.start_rank < 50000}.reverse
	end
end
