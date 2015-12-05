class Gameboard

	attr_reader :array
	attr_accessor :occupied_spaces

  def initialize
    @spaces = spaces
    @occupied_spaces = []
=begin
    y = 1
    (:A..:H).each do |x|
      while y < 3
        @occupied_spaces << [x,y]
        y += 1
      end
			y = 7
      while y < 9
        @occupied_spaces << [x,y]
        y += 1
      end
    end
=end
  end

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