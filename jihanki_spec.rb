# coding: utf-8

require './jihanki'
require './money'
describe Jihanki do
	it "get_toltal() with initial state " do
		Jihanki.new.get_toltal.should eq(0)
	end

	it "money" do 
		Money::YEN_10.should eq(10)
		Money::YEN_50.should eq(50)
	end

	it "投入 10円を入れたら10円取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_10)
		ope.get_toltal.should  eq(10)
	end

	it "投入 50円を入れたら10円取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_50)
		ope.get_toltal.should  eq(50)
	end

	it "投入 二回投入して合計を取得できる" do
		ope = Jihanki.new
		ope.insert(Money::YEN_50)
		ope.insert(Money::YEN_1000)
		ope.get_toltal.should  eq(1050)
	end
end

