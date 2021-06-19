require 'csv'
require 'time'
date_range = (2015..2020)
start_time_month = "05-04"
end_day_month = "05-10"
def format_price(price)
	result = price.to_s
	if result[0] == "$" 
		result[1..-1]
	else
		result
	end
end

def get_price(result_hash, date)
	result = nil
	index = 0
	loop do
		start_time  = Time.parse(date)
		#date_format = "%m/%d/%Y"
		date_format = "%Y-%m-%d"
		parsed_time = start_time.strftime(date_format)
		#puts parsed_time + result_hash[parsed_time].to_s
		if result_hash[parsed_time] || index > 10
			result = result_hash[parsed_time]
			break
		end
		index = index + 1
		next_day = start_time.day + 1
		date = start_time.year.to_s + "-" + start_time.month.to_s + "-" + next_day.to_s
	end
	format_price(result)	
end

data = CSV.read(ARGV[0])
result_hash = data.collect{ |row| [row[0], row[1].strip] }.to_h
puts result_hash
date_range.to_a.each do |year|
	start_time = "#{year}-#{start_time_month}"
	end_time = "#{year}-#{end_day_month}"
	cost_price = get_price(result_hash, start_time).to_f
	sale_price = get_price(result_hash, end_time).to_f
	profit = (sale_price - cost_price)/cost_price * 100
	puts "#{year} ===> #{profit} ======> #{cost_price}, #{sale_price}"
end
