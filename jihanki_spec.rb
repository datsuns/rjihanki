# coding: utf-8

require './jihanki'
require './money'
require './juice'
require './stock'
describe Jihanki do
	before(:each) do 
		@jihanki = Jihanki.new
	end

	after(:each) do 
	end

	it "初期状態での払い戻しは0円" do
		@jihanki.get_total.should eq(0)
	end

	it "お金の定義の確認" do 
		Money::YEN_10.should eq(10)
		Money::YEN_50.should eq(50)
	end

	it "投入 10円を入れたら10円取得できる" do
		@jihanki.insert(Money::YEN_10)
		@jihanki.get_total.should  eq(10)
	end

	it "投入 50円を入れたら50円取得できる" do
		@jihanki.insert(Money::YEN_50)
		@jihanki.get_total.should  eq(50)
	end

	it "投入 二回投入して合計を取得できる" do
		@jihanki.insert(Money::YEN_50)
		@jihanki.insert(Money::YEN_1000)
		@jihanki.get_total.should  eq(1050)
	end

	it "投入せずに払い戻しで0円を返す" do
		@jihanki.payback.should eq(0)
		@jihanki.get_total.should eq(0)
	end

	it "10円投入して払い戻しで10円を返す" do
		@jihanki.insert(Money::YEN_10)
		@jihanki.payback.should eq(10)
		@jihanki.get_total.should eq(0)
	end

	it "10円,100円,1000円投入して払い戻しで1110円を返す" do
		@jihanki.insert(Money::YEN_10)
		@jihanki.insert(Money::YEN_100)
		@jihanki.insert(Money::YEN_1000)
		@jihanki.payback.should eq(1110)
		@jihanki.get_total.should eq(0)
	end

	it "投入して払い戻しの3回繰り返し" do
		@jihanki.insert(Money::YEN_10)
		@jihanki.payback.should eq(10)
		@jihanki.get_total.should eq(0)

		@jihanki.insert(Money::YEN_100)
		@jihanki.payback.should eq(100)
		@jihanki.get_total.should eq(0)

		@jihanki.insert(Money::YEN_1000)
		@jihanki.payback.should eq(1000)
		@jihanki.get_total.should eq(0)
	end
	
	it "想定外のお金を入力するとそのまま返ってくる" do
		@jihanki.insert(1).should eq(1)
		@jihanki.get_total.should eq(0)

		@jihanki.insert(5).should eq(5)
		@jihanki.get_total.should eq(0)

		@jihanki.insert(5000).should eq(5000)
		@jihanki.get_total.should eq(0)
	end

	it "お金が許容されるかどうかを判定する。" do
		Money::useable?(Money::YEN_10).should eq(true)
		Money::useable?(Money::YEN_50).should eq(true)
	end

	it "ジュースの生成" do
		juice = Juice.new( Juice::COLA, 120 )
		juice.name.should eq(Juice::COLA)
		juice.price.should eq(120)
	end

	it "ストックの生成" do
		juice = Juice.new( Juice::COLA, 120 )
		stock = Stock.new( juice, 5 )
		stock.juice.name.should eq(Juice::COLA)
		stock.juice.price.should eq(120)
		stock.num.should eq(5)
	end

	it "初期状態で在庫取得するとコーラ,レッドブル、水が5本ずつある" do
		cola = @jihanki.get_stock(Juice::COLA)

		cola.num.should eq(5)
		cola.juice.name.should eq(Juice::COLA)
		cola.juice.price.should eq(120)

		redbull = @jihanki.get_stock(Juice::REDBULL)

		redbull.num.should eq(5)
		redbull.juice.name.should eq(Juice::REDBULL)
		redbull.juice.price.should eq(200)

		water = @jihanki.get_stock(Juice::WATER)

		water.num.should eq(5)
		water.juice.name.should eq(Juice::WATER)
		water.juice.price.should eq(100)
	end

	it "存在しない在庫取得するとNilが返る" do
		@jihanki.get_stock("sprite").should eq(nil)
	end

	it "120円投入するとコーラが買える事がわかる" do
		@jihanki.insert(Money::YEN_100)
		@jihanki.insert(Money::YEN_10)
		@jihanki.insert(Money::YEN_10)
		@jihanki.buyable?(Juice::COLA).should eq(true)
	end

	it "90円投入ではコーラが買えないことがわかる" do
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_50
		@jihanki.buyable?(Juice::COLA).should eq(false)
	end

	it "在庫に無いジュースは購入不可能" do
		@jihanki.buyable?('sprite').should eq(false)
	end

	it "120円投入してコーラが購入できる" do
		@jihanki.insert Money::YEN_100
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_10
		juice = @jihanki.buy('cola')
		juice.name.should eq('cola')
		juice.price.should eq(120)
		@jihanki.get_stock('cola').num.should eq(4)
	end

	it "50円投入してコーラ購入をしても何も変わらない" do
		@jihanki.insert Money::YEN_50
		@jihanki.buy('cola').should eq(nil)
		@jihanki.get_stock('cola').num.should eq(5)
	end

	it "在庫がない場合に何もしない" do
		@jihanki.insert Money::YEN_1000
		@jihanki.buy 'cola'
		@jihanki.buy 'cola'
		@jihanki.buy 'cola'
		@jihanki.buy 'cola'
		@jihanki.buy 'cola'
		@jihanki.buyable?('cola').should eq(false)
		@jihanki.buy('cola').should eq(nil)
		@jihanki.get_stock('cola').num.should eq(0)

		@jihanki.buy('cola').should eq(nil)
		@jihanki.get_stock('cola').num.should eq(0)
	end

	it "コーラを一本買ったら売上金額120円を取得できる" do
		@jihanki.insert Money::YEN_1000
		@jihanki.buy 'cola'
		@jihanki.get_sales.should eq(120)
		@jihanki.payback.should eq(880)
		@jihanki.get_total.should eq(0)
	end

	it "120円投入するとコーラと水が購入可能になる" do
		@jihanki.insert Money::YEN_100
		@jihanki.insert Money::YEN_10
		@jihanki.insert Money::YEN_10
		list = @jihanki.buyable_list
		list.include?(Juice::COLA).should eq(true)
		list.include?(Juice::WATER).should eq(true)
		list.include?(Juice::REDBULL).should eq(false)
	end
end

