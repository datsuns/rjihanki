require './stock'
require './juice'

class Jihanki
	#=====================================
	# 初期化
	def initialize
		@total = 0
		@sales = 0
		@stocks = Hash.new
		@stocks['cola'] = Stock.new( Juice.new('cola',120), 5 )
	end

	#=====================================
	# 総計取得
	def get_total
		@total
	end

	#=====================================
	# 投入
	def insert money
		if Money.useable? money then
			@total += money
			return @total
		else
			return money
		end
	end

	#=====================================
	# 払い戻し
	def payback
		ret = @total
		@total = 0
		ret
	end

	#=====================================
	# 在庫取得
	def get_stock name
		@stocks[name]
	end

	#=====================================
	# 購入判定
	def buyable? name
		stock = get_stock name
		return false if stock == nil 
		stock.num > 0 and @total >= stock.juice.price
	end

	#=====================================
	# 購入
	def buy name
		return nil if not buyable? name
		@sales += @stocks[name].juice.price
		@stocks[name].num -= 1
		@stocks[name].juice
	end

	#=====================================
	# 購入
	def get_sales
		@sales
	end
end
