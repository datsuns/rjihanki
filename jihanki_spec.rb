# coding: utf-8

require './jihanki'
require './money'
require './juice'
require './stock'

describe Money do
  it{ Money::YEN_10.should eq 10 }
  it{ Money::YEN_50.should eq 50 }
end

describe Juice, 'with "Juice::COLA", and "120"' do
  subject{ Juice.new Juice::COLA, 120 }

  its(:name){ should eq Juice::COLA }
  its(:price){ should eq 120 }
end

describe Stock, '5本のコーラの在庫' do
  before{ @stock = Stock.new( Juice.new( Juice::COLA, 120 ), 5 )  }
  subject{ @stock }
  its(:num){ should eq 5 }

  describe '在庫情報の確認' do
    subject{ @stock.juice }
    its(:name){ should eq Juice::COLA }
    its(:price){ should eq 120 }
  end
end

describe Jihanki do
  share_examples_for '存在しない在庫を取得するとnilを返す' do
    it{ subject.get_stock("sprite").should eq nil }
  end

  share_examples_for '現在の投入金額を払い戻せる' do
    it{
      current = subject.get_total
      subject.payback.should eq current
      subject.get_total.should eq 0
    }
  end

  share_examples_for '在庫確認' do |name, num_of_stocks|
    it{
      subject.get_stock(name).num.should eq num_of_stocks
    }
  end

  share_examples_for '購入可能' do |name, price, payback|
    it do
      subject.buy name
      subject.get_sales.should eq price
      subject.payback.should eq payback
      subject.get_total.should eq 0
    end
  end
  
  share_examples_for '購入不可能' do |name|
    it{ should_not be_buyable name }
  end

  share_examples_for '想定外の金額を投入するとそのまま返ってくる' do
    it{ subject.insert(1).should eq 1 }
    it{ subject.insert(5).should eq 5 }
    it{ subject.insert(5000).should eq 5000 }
  end

  share_examples_for 'デフォルト動作ができる' do
    it_should_behave_like '存在しない在庫を取得するとnilを返す' 
    it_should_behave_like '現在の投入金額を払い戻せる' 
  end

  context '初期状態' do
    before{ @jihanki = Jihanki.new  }
    subject{ @jihanki }

    it_should_behave_like 'デフォルト動作ができる' 
    it_should_behave_like '想定外の金額を投入するとそのまま返ってくる' 
    it_should_behave_like '在庫確認', Juice::COLA, 5
    it_should_behave_like '在庫確認', Juice::REDBULL, 5
    it_should_behave_like '在庫確認', Juice::WATER, 5

    its(:get_total){ should eq 0 }
    its(:payback){ should eq 0 }

    it '投入と払い戻しを繰り返せる' do
      subject.insert Money::YEN_10
      subject.payback.should eq 10
      subject.get_total.should eq 0

      subject.insert Money::YEN_100
      subject.payback.should eq 100
      subject.get_total.should eq 0

      subject.insert Money::YEN_1000
      subject.payback.should eq 1000
      subject.get_total.should eq 0
    end
  end

  context '10円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert Money::YEN_10
      jihanki
    end

    it_should_behave_like 'デフォルト動作ができる' 
    its(:get_total){ should eq 10 }
    its(:payback){ should eq 10 }
  end

  context '50円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert Money::YEN_50
      jihanki
    end

    it_should_behave_like 'デフォルト動作ができる' 
    it_should_behave_like '購入不可能', Juice::COLA
    its(:get_total){ should eq 50 }
  end

  context '90円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert Money::YEN_50
      jihanki.insert Money::YEN_10
      jihanki.insert Money::YEN_10
      jihanki.insert Money::YEN_10
      jihanki.insert Money::YEN_10
      jihanki
    end

    it_should_behave_like 'デフォルト動作ができる' 
    its(:buyable_list){ should_not include Juice::COLA  }
    its(:buyable_list){ should_not include Juice::WATER }
    its(:buyable_list){ should_not include Juice::REDBULL }
  end

  context '120円投入状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert Money::YEN_100
      jihanki.insert Money::YEN_10
      jihanki.insert Money::YEN_10
      jihanki
    end

    it_should_behave_like 'デフォルト動作ができる' 
    its(:buyable_list){ should include Juice::COLA  }
    its(:buyable_list){ should include Juice::WATER }
    its(:buyable_list){ should_not include Juice::REDBULL }

    it 'コーラを購入すると在庫数が減る' do
      juice = subject.buy Juice::COLA
      juice.name.should eq Juice::COLA
      juice.price.should eq 120
      subject.get_stock(Juice::COLA).num.should eq 4
    end

    it "コーラを買って売上金額とお釣り(0円)を取得できる" do
      subject.buy 'cola'
      subject.get_sales.should eq 120
      subject.payback.should eq 0
      subject.get_total.should eq 0
    end
  end


  context '二回で合計1050円投入する' do
    subject{
      j = Jihanki.new
      j.insert Money::YEN_50
      j.insert Money::YEN_1000
      j
    }
    it_should_behave_like 'デフォルト動作ができる' 
    its(:get_total){ should eq 1050 }
    it_should_behave_like '購入可能', Juice::COLA, 120, 930
  end

  context '在庫が切れた状態' do
    subject do
      jihanki = Jihanki.new
      jihanki.insert Money::YEN_1000
      jihanki.buy 'cola'
      jihanki.buy 'cola'
      jihanki.buy 'cola'
      jihanki.buy 'cola'
      jihanki.buy 'cola'
      jihanki
    end
    it_should_behave_like '購入不可能', Juice::COLA
  end


end

