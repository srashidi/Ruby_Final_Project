class Gameboard

	attr_reader :array
	attr_accessor :occupied_spaces

  def initialize
    @spaces = []
    x,y = 0,0
    while x < 8
      while y < 8
        @spaces << [x,y]
        y += 1
      end
      x += 1
      y = 0
    end
    @occupied_spaces = []
  end

end