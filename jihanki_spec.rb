# coding: utf-8

require './jihanki'
require './money'
describe Jihanki do
	before(:each) do 
		@jihanki = Jihanki.new
	end

	after(:each) do 
	end


	it "get_total() with initial state " do
		@jihanki.get_total.should eq(0)
	end

	it "money" do 
		Money::YEN_10.should eq(10)
		Money::YEN_50.should eq(50)
	end

	it "投入 10円を入れたら10円取得できる" do
		@jihanki.insert(Money::YEN_10)
		@jihanki.get_total.should  eq(10)
	end

	it "投入 50円を入れたら10円取得できる" do
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
end

