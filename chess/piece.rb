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

end