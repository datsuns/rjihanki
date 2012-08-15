#
# 大阪TDDBC課題
# URL: http://devtesting.jp/tddbc/?TDDBC%E5%A4%A7%E9%98%AA2.0%2F%E8%AA%B2%E9%A1%8C
#
require './stock'
require './juice'
require './money'

class Jihanki
	COLA = Juice.new( Juice::COLA, 120 )
	REDBULL = Juice.new( Juice::REDBULL, 200 )
	WATER = Juice.new( Juice::WATER, 100 )
  MONEY_RANGE = [
    Money::YEN_10, Money::YEN_50, Money::YEN_100,
    Money::YEN_500, Money::YEN_500, Money::YEN_1000
  ]

	#=====================================
	# 初期化
	def initialize
		@total = 0
		@sales = 0

		@stocks = Hash.new
		@stocks[COLA.name] = Stock.new( COLA, 5 )
		@stocks[REDBULL.name] = Stock.new( REDBULL, 5 )
		@stocks[WATER.name] = Stock.new( WATER, 5 )
	end

	#=====================================
	# 総計取得
	def get_total
		@total
	end

	#=====================================
	# 投入
	def insert money
		return money if not useable? money
		@total += money
		@total
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
		@total -= @stocks[name].juice.price
		@stocks[name] - 1
		@stocks[name].juice
	end

	#=====================================
	# 売上金額取得
	def get_sales
		@sales
	end

	#=====================================
	# 購入可能リスト取得
	def buyable_list
		list = Array.new
		@stocks.each do |key, stock|
			list << stock.juice.name if buyable? stock.juice.name
		end
		list
	end

	def useable? input
		MONEY_RANGE.include? input
	end
end
