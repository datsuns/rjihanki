require './stock'

class Jihanki
	@total
	@allStock

	def initialize
		@total = 0
		@allStock = Hash.new
		@allStock['cola'] =  Stock.new( Juice.new('cola',120), 5 )
	end

	def get_total
		@total
	end

	def insert money
		if Money.useable? money then
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

	def get_stock name
		@allStock[name]
	end
end
