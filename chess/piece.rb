class Piece

	attr_reader :type, :color, :view
	attr_accessor :position

	def initialize(type,color,position,moving=false)
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
		hash = {}
		x,y = @position[0],@position[1]
		case @type
		when :king
			hash[:east] = [[x.next,y]]
			hash[:northeast] = [[x.next,y+1]]
			hash[:north] = [[x,y+1]]
			hash[:northwest] = [[x.prev,y+1]]
			hash[:west] = [[x.prev,y]]
			hash[:southwest] = [[x.prev,y-1]]
			hash[:south] = [[x,y-1]]
			hash[:southeast] = [[x.next,y-1]]
		when :queen
			hash[:east] = [[x.next,y]]
			hash[:northeast] = [[x.next,y+1]]
			hash[:north] = [[x,y+1]]
			hash[:northwest] = [[x.prev,y+1]]
			hash[:west] = [[x.prev,y]]
			hash[:southwest] = [[x.prev,y-1]]
			hash[:south] = [[x,y-1]]
			hash[:southeast] = [[x.next,y-1]]
			i = 0
			6.times do
				hash[:east] << [hash[:east][i][0].next,y]
				hash[:northeast] << [hash[:northeast][i][0].next,hash[:northeast][i][1]+1]
				hash[:north] << [x,hash[:north][i][1]+1]
				hash[:northwest] << [hash[:northwest][i][0].prev,hash[:northwest][i][1]+1]
				hash[:west] << [hash[:west][i][0].prev,y]
				hash[:southwest] << [hash[:southwest][i][0].prev,hash[:southwest][i][1]-1]
				hash[:south] << [x,hash[:south][i][1]-1]
				hash[:southeast] << [hash[:southeast][i][0].next,hash[:southeast][i][1]-1]
				i += 1
			end
		when :rook
			hash[:east] = [[x.next,y]]
			hash[:north] = [[x,y+1]]
			hash[:west] = [[x.prev,y]]
			hash[:south] = [[x,y-1]]
			i = 0
			6.times do
				hash[:east] << [hash[:east][i][0].next,y]
				hash[:north] << [x,hash[:north][i][1]+1]
				hash[:west] << [hash[:west][i][0].prev,y]
				hash[:south] << [x,hash[:south][i][1]-1]
				i += 1
			end
		when :bishop
			hash[:northeast] = [[x.next,y+1]]
			hash[:northwest] = [[x.prev,y+1]]
			hash[:southwest] = [[x.prev,y-1]]
			hash[:southeast] = [[x.next,y-1]]
			i = 0
			6.times do
				hash[:northeast] << [hash[:northeast][i][0].next,hash[:northeast][i][1]+1]
				hash[:northwest] << [hash[:northwest][i][0].prev,hash[:northwest][i][1]+1]
				hash[:southwest] << [hash[:southwest][i][0].prev,hash[:southwest][i][1]-1]
				hash[:southeast] << [hash[:southeast][i][0].next,hash[:southeast][i][1]-1]
				i += 1
			end
		when :knight
			hash[:northeast] = [[x.next,y+2]]
			hash[:southeast] = [[x.next,y-2]]
			hash[:northwest] = [[x.prev,y+2]]
			hash[:southwest] = [[x.prev,y-2]]
			hash[:eastnorth] = [[x.next.next,y+1]]
			hash[:eastsouth] = [[x.next.next,y-1]]
			hash[:westnorth] = [[x.prev.prev,y+1]]
			hash[:westsouth] = [[x.prev.prev,y-1]]
		when :pawn
			case @color
			when :white
				hash[:forward] = [[x,y+1]]
				hash[:diagonaleast] = [[x.next,y+1]]
				hash[:diagonalwest] = [[x.prev,y+1]]
			when :black
				hash[:forward] = [[x,y-1]]
				hash[:diagonaleast] = [[x.next,y-1]]
				hash[:diagonalwest] = [[x.prev,y-1]]
			end
		end
		final_hash = {}
		hash.each do |direction,moves|
			final_hash[direction] = moves & spaces
		end
		final_hash
	end

	private

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