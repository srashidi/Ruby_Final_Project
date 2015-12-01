class Gameboard

  WHITE_KING = "\u{2654}"
  WHITE_QUEEN = "\u{2655}"
  WHITE_ROOK = "\u{2656}"
  WHITE_BISHOP = "\u{2657}"
  WHITE_KNIGHT = "\u{2658}"
  WHITE_PAWN = "\u{2659}"
  BLACK_KING = "\u{265A}"
  BLACK_QUEEN = "\u{265B}"
  BLACK_ROOK = "\u{265C}"
  BLACK_BISHOP = "\u{265D}"
  BLACK_KNIGHT = "\u{265E}"
  BLACK_PAWN = "\u{265F}"

  def initialize
    @array = []
    x,y = 0,0
    while x < 8
      while y < 8
        @array << [x,y]
        y += 1
      end
      x += 1
      y = 0
    end
  end

end