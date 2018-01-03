module Players
  class Human < Player

    def move(board)
      puts "Enter move"
      input = gets.chomp
      if !board.valid_move?(input)
        self.move(board)
      end
      player_move = input
    end
  end
end
