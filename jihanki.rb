class Jihanki
	@total

	def initialize
		@total = 0
	end

	def get_total
		@total
	end

	def insert money
		if Money.money? money then
			@total += money
			return @total
		else
			return money
		end
	end

	def payback
		retval = @total
		@total = 0
		retval
	end
end
