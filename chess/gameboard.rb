require './piece'

class Gameboard

	attr_reader :array
	attr_accessor :occupied_spaces

  def initialize
    @spaces = []
    y = 1
    ("a".."h").each do |x|
      while y < 8
        @spaces << [x,y]
        y += 1
      end
      y = 1
    end
    @occupied_spaces = []
    ("a".."h").each do |x|
      while y < 3
        @occupied_spaces << [x,y]
        y += 1
      end
    end
    y = 7
    ("a".."h").each do |x|
      while y < 9
        @occupied_spaces << [x,y]
        y += 1
      end
    end
  end

  def place_piece(piece,space)

  end

end