# coding: utf-8

require './jihanki'
require './money'
describe Jihanki do
	it "get_total() with initial state " do
		Jihanki.new.get_total.should eq(0)
	end

	it "money" do 
		Money::YEN_10.should eq(10)
		Money::YEN_50.should eq(50)
	end

	it "投入 10円を入れたら10円取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_10)
		ope.get_total.should  eq(10)
	end

	it "投入 50円を入れたら10円取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_50)
		ope.get_total.should  eq(50)
	end

	it "投入 二回投入して合計を取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_50)
		ope.insert(Money::YEN_1000)
		ope.get_total.should  eq(1050)
	end

	it "投入せずに払い戻しで0円を返す" do
		ope = Jihanki.new
		ope.payback.should eq(0)
		ope.get_total.should eq(0)
	end

	it "10円投入して払い戻しで10円を返す" do
		ope = Jihanki.new
		ope.insert(Money::YEN_10)
		ope.payback.should eq(10)
		ope.get_total.should eq(0)
	end

	it "10円,100円,1000円投入して払い戻しで1110円を返す" do
		ope = Jihanki.new
		ope.insert(Money::YEN_10)
		ope.insert(Money::YEN_100)
		ope.insert(Money::YEN_1000)
		ope.payback.should eq(1110)
		ope.get_total.should eq(0)
	end

	it "投入して払い戻しの3回繰り返し" do
		ope = Jihanki.new
		ope.insert(Money::YEN_10)
		ope.payback.should eq(10)
		ope.get_total.should eq(0)
		ope.insert(Money::YEN_100)
		ope.payback.should eq(100)
		ope.get_total.should eq(0)
		ope.insert(Money::YEN_1000)
		ope.payback.should eq(1000)
		ope.get_total.should eq(0)
	end
end

