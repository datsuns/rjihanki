require './stock'
require './juice'

class Jihanki
	@total
	@stocks

	def initialize
		@total = 0
		@stocks = Hash.new
		@stocks['cola'] = Stock.new( Juice.new('cola',120), 5 )
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
		ret = @total
		@total = 0
		ret
	end

	def get_stock name
		@stocks[name]
	end

	def buyable name
		stock = get_stock name
		return false if stock == nil 
		stock.num and @total >= stock.juice.price
	end
end
