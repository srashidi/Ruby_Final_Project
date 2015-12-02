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
			array << [x.next,y]
			array << [x.next,y+1]
			array << [x,y+1]
			array << [x.prev,y+1]
			array << [x.prev,y]
			array << [x.prev,y-1]
			array << [x,y-1]
			array << [x.next,y-1]
		when :queen
			array << [x.next,y]
			array << [x.next,y+1]
			array << [x,y+1]
			array << [x.prev,y+1]
			array << [x.prev,y]
			array << [x.prev,y-1]
			array << [x,y-1]
			array << [x.next,y-1]
			i = 0
			6.times do
				array << [array[i][0].next,y]
				array << [array[i+1][0].next,array[i+1][1]+1]
				array << [x,array[i+2][1]+1]
				array << [array[i+3][0].prev,array[i+3][1]+1]
				array << [array[i+4][0].prev,y]
				array << [array[i+5][0].prev,array[i+5][1]-1]
				array << [x,array[i+6][1]-1]
				array << [array[i+7][0].next,array[i+7][1]-1]
				i += 8
			end
		end
		array
	end

end

class Symbol

	def prev
		(self.to_s.ord - 1).chr.to_sym
	end

end