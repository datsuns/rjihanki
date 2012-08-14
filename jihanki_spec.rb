# coding: utf-8

require './jihanki'
require './money'
require './juice'
require './stock'

describe Money do
	it "定義が正しい" do 
		Money::YEN_10.should eq(10)
		Money::YEN_50.should eq(50)
	end

	it "使用可能なお金が規定できている" do
		Money::useable?(Money::YEN_10).should eq(true)
		Money::useable?(Money::YEN_50).should eq(true)
	end
end


describe Jihanki do
  subject{ Jihanki.new }

  context '初期状態' do
    its(:get_total){ should eq(0) }
  end


	it "投入 10円を入れたら10円取得できる" do
		subject.insert(Money::YEN_10)
		subject.get_total.should  eq(10)
	end

	it "投入 50円を入れたら50円取得できる" do
		subject.insert(Money::YEN_50)
		subject.get_total.should  eq(50)
	end

	it "投入 二回投入して合計を取得できる" do
		subject.insert(Money::YEN_50)
		subject.insert(Money::YEN_1000)
		subject.get_total.should  eq(1050)
	end

	it "投入せずに払い戻しで0円を返す" do
		subject.payback.should eq(0)
		subject.get_total.should eq(0)
	end

	it "10円投入して払い戻しで10円を返す" do
		subject.insert(Money::YEN_10)
		subject.payback.should eq(10)
		subject.get_total.should eq(0)
	end

	it "10円,100円,1000円投入して払い戻しで1110円を返す" do
		subject.insert(Money::YEN_10)
		subject.insert(Money::YEN_100)
		subject.insert(Money::YEN_1000)
		subject.payback.should eq(1110)
		subject.get_total.should eq(0)
	end

	it "投入して払い戻しの3回繰り返し" do
		subject.insert(Money::YEN_10)
		subject.payback.should eq(10)
		subject.get_total.should eq(0)

		subject.insert(Money::YEN_100)
		subject.payback.should eq(100)
		subject.get_total.should eq(0)

		subject.insert(Money::YEN_1000)
		subject.payback.should eq(1000)
		subject.get_total.should eq(0)
	end
	
	it "想定外のお金を入力するとそのまま返ってくる" do
		subject.insert(1).should eq(1)
		subject.get_total.should eq(0)

		subject.insert(5).should eq(5)
		subject.get_total.should eq(0)

		subject.insert(5000).should eq(5000)
		subject.get_total.should eq(0)
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
		cola = subject.get_stock(Juice::COLA)

		cola.num.should eq(5)
		cola.juice.name.should eq(Juice::COLA)
		cola.juice.price.should eq(120)

		redbull = subject.get_stock(Juice::REDBULL)

		redbull.num.should eq(5)
		redbull.juice.name.should eq(Juice::REDBULL)
		redbull.juice.price.should eq(200)

		water = subject.get_stock(Juice::WATER)

		water.num.should eq(5)
		water.juice.name.should eq(Juice::WATER)
		water.juice.price.should eq(100)
	end

	it "存在しない在庫取得するとNilが返る" do
		subject.get_stock("sprite").should eq(nil)
	end

	it "120円投入するとコーラが買える事がわかる" do
		subject.insert(Money::YEN_100)
		subject.insert(Money::YEN_10)
		subject.insert(Money::YEN_10)
		subject.buyable?(Juice::COLA).should eq(true)
	end

	it "90円投入ではコーラが買えないことがわかる" do
		subject.insert Money::YEN_10
		subject.insert Money::YEN_10
		subject.insert Money::YEN_10
		subject.insert Money::YEN_10
		subject.insert Money::YEN_50
		subject.buyable?(Juice::COLA).should eq(false)
	end

	it "在庫に無いジュースは購入不可能" do
		subject.insert Money::YEN_1000
		subject.buyable?('sprite').should eq(false)
	end

	it "120円投入してコーラが購入できる" do
		subject.insert Money::YEN_100
		subject.insert Money::YEN_10
		subject.insert Money::YEN_10
		juice = subject.buy('cola')
		juice.name.should eq('cola')
		juice.price.should eq(120)
		subject.get_stock('cola').num.should eq(4)
	end

	it "50円投入してコーラ購入をしても何も変わらない" do
		subject.insert Money::YEN_50
		subject.buy('cola').should eq(nil)
		subject.get_stock('cola').num.should eq(5)
	end

	it "在庫がない場合に何もしない" do
		subject.insert Money::YEN_1000
		subject.buy 'cola'
		subject.buy 'cola'
		subject.buy 'cola'
		subject.buy 'cola'
		subject.buy 'cola'
		subject.buyable?('cola').should eq(false)
		subject.buy('cola').should eq(nil)
		subject.get_stock('cola').num.should eq(0)

		subject.buy('cola').should eq(nil)
		subject.get_stock('cola').num.should eq(0)
	end

	it "コーラを一本買ったら売上金額120円を取得できる" do
		subject.insert Money::YEN_1000
		subject.buy 'cola'
		subject.get_sales.should eq(120)
		subject.payback.should eq(880)
		subject.get_total.should eq(0)
	end

	it "120円投入するとコーラと水が購入可能になる" do
		subject.insert Money::YEN_100
		subject.insert Money::YEN_10
		subject.insert Money::YEN_10
		list = subject.buyable_list
		list.include?(Juice::COLA).should eq(true)
		list.include?(Juice::WATER).should eq(true)
		list.include?(Juice::REDBULL).should eq(false)
	end
end

