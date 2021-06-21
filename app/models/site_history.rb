class SiteHistory < ApplicationRecord
	belongs_to :top_site

	def abs_percentage
		diff = (self.end_rank - self.start_rank).abs
		diff * 100/(start_rank * 1.0)
	end
	
end
