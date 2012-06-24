class Money
	YEN_10 = 10
	YEN_50 = 50
	YEN_100 = 100
	YEN_500 = 500
	YEN_1000 = 1000

	RANGE = [ YEN_10, YEN_50, YEN_100, YEN_500, YEN_500, YEN_1000 ]

	def self.money? input
		RANGE.include? input
	end
end

