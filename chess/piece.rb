class Piece

	attr_reader :type, :color, :view
	attr_accessor :position

	def initialize(type,color,position)
		@type = type
		@color = color
		@position = position
		@view = case color
		when :white
			case type
			when :king then "\u{2654}"
			when :queen then "\u{2655}"
			when :rook then "\u{2656}"
			when :bishop then "\u{2657}"
			when :knight then "\u{2658}"
			when :pawn then "\u{2659}"
			end
		when :black
			case type
			when :king then "\u{265A}"
			when :queen then "\u{265B}"
			when :rook then "\u{265C}"
			when :bishop then "\u{265D}"
			when :knight then "\u{265E}"
			when :pawn then "\u{265F}"
			end
		end
	end

	def possible_moves
		array = []
		x,y = position[0],position[1]
		case @type
		when :king
			array << [[x.next,y]]
			array << [[x.next,y+1]]
			array << [[x,y+1]]
			array << [[x.prev,y+1]]
			array << [[x.prev,y]]
			array << [[x.prev,y-1]]
			array << [[x,y-1]]
			array << [[x.next,y-1]]
		when :queen
			array << [[x.next,y]]
			array << [[x.next,y+1]]
			array << [[x,y+1]]
			array << [[x.prev,y+1]]
			array << [[x.prev,y]]
			array << [[x.prev,y-1]]
			array << [[x,y-1]]
			array << [[x.next,y-1]]
			i = 0
			6.times do
				array[0] << [array[0][i][0].next,y]
				array[1] << [array[1][i][0].next,array[1][i][1]+1]
				array[2] << [x,array[2][i][1]+1]
				array[3] << [array[3][i][0].prev,array[3][i][1]+1]
				array[4] << [array[4][i][0].prev,y]
				array[5] << [array[5][i][0].prev,array[5][i][1]-1]
				array[6] << [x,array[6][i][1]-1]
				array[7] << [array[7][i][0].next,array[7][i][1]-1]
				i += 1
			end
		when :rook
			array << [[x.next,y]]
			array << [[x,y+1]]
			array << [[x.prev,y]]
			array << [[x,y-1]]
			i = 0
			6.times do
				array[0] << [array[0][i][0].next,y]
				array[1] << [x,array[1][i][1]+1]
				array[2] << [array[2][i][0].prev,y]
				array[3] << [x,array[3][i][1]-1]
				i += 1
			end
		when :bishop
			array << [[x.next,y+1]]
			array << [[x.prev,y+1]]
			array << [[x.prev,y-1]]
			array << [[x.next,y-1]]
			i = 0
			6.times do
				array << [array[0][i][0].next,array[0][i][1]+1]
				array << [array[1][i][0].prev,array[1][i][1]+1]
				array << [array[2][i][0].prev,array[2][i][1]-1]
				array << [array[3][i][0].next,array[3][i][1]-1]
				i += 1
			end
		when :knight
			array << [[x.next,y+2]]
			array << [[x.next,y-2]]
			array << [[x.prev,y+2]]
			array << [[x.prev,y-2]]
			array << [[x.next.next,y+1]]
			array << [[x.next.next,y-1]]
			array << [[x.prev.prev,y+1]]
			array << [[x.prev.prev,y-1]]
		when :pawn
			case @type
			when :white
				array << [[x,y+1]]
				array << [[x.next,y+1]]
				array << [[x.prev,y+1]]
			when :black
				array << [[x,y-1]]
				array << [[x.next,y-1]]
				array << [[x.prev,y-1]]
			end
		end
		final_array = []
		array.each_with_index do |moves,index|
			final_array[index] = moves & spaces
		end
		final_array
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

class Symbol

	def prev
		(self.to_s.ord - 1).chr.to_sym
	end

end