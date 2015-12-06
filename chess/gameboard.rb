class Gameboard

	# Makes the spaces readable and the occupied spaces accessible
	attr_reader :spaces
	attr_accessor :occupied_spaces

	# Creates a gameboard with unoccupied spaces
  def initialize
    @spaces = spaces
    @occupied_spaces = []
  end

	# Generates spaces for a gameboard
  def spaces
  	array = []
    y = 1
    (:A..:H).each do |x|
      while y < 9
        array << [x,y]
        y += 1
      end
      y = 1
    end
    array
  end

end