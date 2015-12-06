require_relative '../chess'
require_relative '../gameboard'
require_relative '../piece'

class Chess

	attr_reader :test_mode, :gameboard, :pieces

	def initialize(test_mode)
		@test_mode = test_mode
	end

end