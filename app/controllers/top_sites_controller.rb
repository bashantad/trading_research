class TopSitesController < ApplicationController
	def index
		top_sites = TopSite.all.where("country_rank > ? and country_rank < ?", 0, 500)
		@histories = SiteHistory.where(:top_site_id => top_sites.collect(&:id)).sort do |a, b|
			a.abs_percentage <=> b.abs_percentage
		end.select { |a| a.end_rank < a.start_rank  && a.abs_percentage > 40 }.reverse
	end
end
