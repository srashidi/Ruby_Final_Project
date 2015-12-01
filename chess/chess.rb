require './gameboard'

class Chess

	def initialize
		@gameboard = Gameboard.new
	end

	def position_check(position)
    @gameboard.array.include?(position)
  end

end