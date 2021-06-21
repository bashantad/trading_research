class TopSitesController < ApplicationController
	def index
		stock_names = Stock.all.collect(&:display_website).compact
		top_sites = TopSite.all.where(:company_url => stock_names)
		@histories = SiteHistory.where(:top_site_id => top_sites.collect(&:id)).sort do |a, b|
			a.abs_percentage <=> b.abs_percentage
		end.select { |a| a.end_rank > a.start_rank }.reverse
	end
end
