require "rails_helper"
require "pry"

RSpec.describe TrafficsController, type: :controller do
	def save_into_file(ranks, engagements, engagement_string)
		sitename, country, country_rank, start_rank, end_rank = ranks
		daily_page_views, daily_page_views_percentage, daily_time_on_site, daily_time_on_site_percentage, bounce_rate, bounce_rate_percentage = engagements
		data = {
			:sitename => sitename,
			:country => country,
			:country_rank => country_rank,
			:start_rank => start_rank,
			:end_rank => end_rank,
			:daily_page_views => daily_page_views,
			:daily_page_views_percentage => daily_page_views_percentage,
			:daily_time_on_site => daily_time_on_site,
			:daily_time_on_site_percentage => daily_time_on_site_percentage,
			:bounce_rate => bounce_rate,
			:bounce_rate_percentage => bounce_rate_percentage,
			:engagement_string => engagement_string,
		}

		open(Rails.root.join("spec/controllers/history.txt"), 'a') do |f|
  			f.puts data.to_json
		end		
	end

	def fetch_traffic(sitename)
		visit "https://alexa.com/siteinfo/#{sitename}#section_traffic"
		country_tag       = find("#CountryRank").text.split("\n")
		country           = country_tag.first
		country_rank      = country_tag.last.gsub(",", "")
		start_rank        = find(".start-rank .rank").text.gsub(",", "")
		end_rank          = find(".end-rank .rank").text.gsub(",", "")
		engagement_string = find(".engagement").text
		engagements       = engagement_string.split("\n").select { |a| !a.scan(/\d/).empty? }[1..-1]
		ranks             = [sitename, country, country_rank, start_rank, end_rank]
		save_into_file(ranks, engagements, engagement_string)
	end

	def finished_sites
		[]
	end

	it "records responses" do
		sites = TopSite::TOP_SITES_500.shuffle
		filtered_sites = sites.reject { |a| a.include?(".gov") || a.include?(".edu") }
		arr = (2..5).to_a
		(filtered_sites - finished_sites).each do |sitename|
			begin
				fetch_traffic(sitename)
				puts "Finished fetching data for #{sitename}"
			rescue => e
				puts "===== had an issue with #{sitename}"
			end
			interval = arr.sample
			sleep interval
		end
	end
end
