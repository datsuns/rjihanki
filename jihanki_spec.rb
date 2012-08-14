# coding: utf-8

require './jihanki'
require './money'
require './juice'
require './stock'

describe Money do
  it{ Money::YEN_10.should eq 10 }
  it{ Money::YEN_50.should eq 50 }
	it{ Money.useable?(Money::YEN_10).should be_true }
	it{ Money.useable?(Money::YEN_50).should be_true }
end

describe Juice, 'with "Juice::COLA", and "120"' do
  subject{ Juice.new Juice::COLA, 120 }

  its(:name){ should eq Juice::COLA }
  its(:price){ should eq 120 }
end

describe Stock, '5本のコーラの在庫' do
  subject{ Stock.new( Juice.new( Juice::COLA, 120 ), 5 ) }

  it{ subject.juice.name.should eq Juice::COLA }
  it{ subject.juice.price.should eq 120 }
  its(:num){ should eq 5 }
end

describe Jihanki do
  subject{ Jihanki.new }

  share_examples_for '存在しない在庫を取得するとnilを返す' do
      it{ subject.get_stock("sprite").should eq nil }
  end

  context '初期状態' do
    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    its(:get_total){ should eq(0) }
    its(:payback){ should eq(0) }

    it 'コーラの在庫が5本ある' do
      cola = subject.get_stock(Juice::COLA)
      cola.num.should eq(5)
      cola.juice.name.should eq(Juice::COLA)
      cola.juice.price.should eq(120)
    end

    it 'レッドブルの在庫が5本ある' do
      redbull = subject.get_stock(Juice::REDBULL)
      redbull.num.should eq(5)
      redbull.juice.name.should eq(Juice::REDBULL)
      redbull.juice.price.should eq(200)
    end

    it '水の在庫が5本ある' do
      water = subject.get_stock(Juice::WATER)
      water.num.should eq(5)
      water.juice.name.should eq(Juice::WATER)
      water.juice.price.should eq(100)
    end

    it '投入と払い戻しを繰り返せる' do
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
  end

  context '10円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert(Money::YEN_10)
      jihanki
    end

    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    its(:get_total){ should eq 10 }

    it "払い戻しで10円を返す" do
      subject.payback.should eq(10)
      subject.get_total.should eq(0)
    end
  end

  context '50円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert(Money::YEN_50)
      jihanki
    end

    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    its(:get_total){ should eq(50) }
  end

  context '120円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert(Money::YEN_100)
      jihanki.insert(Money::YEN_10)
      jihanki.insert(Money::YEN_10)
      jihanki
    end

    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    its(:buyable_list){ should include Juice::COLA  }
    its(:buyable_list){ should include Juice::WATER }
    its(:buyable_list){ should_not include Juice::REDBULL }
  end

  context '想定外のお金を投入するとそのまま戻ってくる' do
    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    context '1円を投入' do
      it{ subject.insert(1).should eq(1) }
    end

    context '5円を投入' do
      it{ subject.insert(5).should eq(5) }
    end

    context '5000円を投入' do
      it{ subject.insert(5000).should eq(5000) }
    end
  end

  context '二回で合計1050円投入する' do
    subject{
      j = Jihanki.new
      j.insert(Money::YEN_50)
      j.insert(Money::YEN_1000)
      j
    }
    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    its(:get_total){ should eq 1050 }
  end


	it "10円,100円,1000円投入して払い戻しで1110円を返す" do
		subject.insert(Money::YEN_10)
		subject.insert(Money::YEN_100)
		subject.insert(Money::YEN_1000)
		subject.payback.should eq(1110)
		subject.get_total.should eq(0)
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

end

