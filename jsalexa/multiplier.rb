def multiplier(profit)
	if profit > 7
		200
	elsif profit > 5.38
		100
	elsif profit > 5.01
		92.9
	elsif profit > 4.65
		85.7
	elsif profit > 4.28
		78.6
	elsif profit > 3.92
		71.4
	elsif profit > 3.55
		64.3
	elsif profit > 3.18
		57.1
	elsif profit > 2.82
		50
	elsif profit > 2.45
		42.9
	elsif profit > 2.09
		35.7
	elsif profit > 1.72
		28.6
	elsif profit > 1.35
		21.4
	elsif profit > 0.99
		14.3
	elsif profit > 0.62
		7.14
	elsif profit > 0.26
		0
	elsif profit > -0.11
		-7.1
	elsif profit > -0.48
		-14
	elsif profit > -0.84
		-21
	elsif profit > -1.21
		-29
	elsif profit > -1.57
		-36
	elsif profit > -1.94
		-43
	elsif profit > -2.31
		-50
	elsif profit > -2.67
		-57
	elsif profit > -3.04
		-64
	elsif profit > -3.40
		-71
	elsif profit > -3.77 
		-79
	elsif profit > -4.13
		-86
	elsif profit > -4.5
		-93
	else 
		-100
	end
end