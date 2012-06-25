require './juice'
class Stock
	def initialize( juice, num )
		@juice = juice
		@num = num
	end

	attr_reader :juice
	attr_accessor :num
end
