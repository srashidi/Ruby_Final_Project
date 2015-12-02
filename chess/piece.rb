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
			array << [x.next,y.next]
			array << [x,y.next]
			array << [x.prev,y.next]
			array << [x.prev,y]
			array << [x.prev,y-1]
			array << [x,y-1]
			array << [x.next,y-1]
		end
	end

end

class Symbol

	def prev
		(self.to_s.ord - 1).chr.to_sym
	end

end