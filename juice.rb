class Juice
	COLA = 'cola'
	REDBULL = 'redbull'
	WATER = 'water'

	def initialize( name, price )
		@name = name
		@price = price
	end

	attr_reader :name, :price
end
