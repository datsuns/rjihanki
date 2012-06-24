class Jihanki
	@total

	def initialize
		@total = 0
	end

	def get_total
		@total
	end

	def insert money
		@total += money
	end

	def payback
		retval = @total
		@total = 0
		retval
	end
end
