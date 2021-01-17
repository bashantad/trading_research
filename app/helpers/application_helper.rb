module ApplicationHelper
	def get_growth_percentage(last_traffic, current_traffic)
		change = (current_traffic - last_traffic) * 1.0
		change/last_traffic * 100.0
	end
end
