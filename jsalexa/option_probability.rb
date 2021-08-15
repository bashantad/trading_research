require 'csv'
require 'time'
date_range = (2015..2020)

start_time_month = "05-04"
end_day_month = "05-10"

def get_date_range
	date_range.to_a.collect do |year|
		start_time = "#{year}-#{start_time_month}"
		end_time = "#{year}-#{end_day_month}"
		[start_time, end_time]
	end
end

def fixed_date_range
	[]
end

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
		begin
			start_time  = Time.parse(date)
		rescue
			puts "error parsing #{date}"
			return 0
		end
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

profits = []
fixed_date_range.each do |start_time, end_time|
	cost_price = get_price(result_hash, start_time).to_f
	sale_price = get_price(result_hash, end_time).to_f
	profit = (sale_price - cost_price)/cost_price * 100
	profits << profit.round(2) if profit.is_a?(Float)
	#puts "#{start_time}: #{profit} ======> #{cost_price}, #{sale_price}"
end

def category(profit)
	if profit < -4
		"zero"
	elsif profit < 0
		"negative"
	elsif profit < 2
		"small"
	elsif profit < 4
		"medium"
	else
		"large"
	end
end

puts profits.group_by { |profit| category(profit) }
puts profits.group_by { |profit| category(profit) }.transform_values {|a| a.count }


