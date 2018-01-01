module Players
  class Computer < Player
    attr_accessor :available, :combo, :winning_combo, :blocking_combo, :current_player
    attr_accessor :diagonal_combo

#    @current_player = self.token
    CENTER = ["5"]
    CORNER = ["1","3","7","9"]
    EDGE = ["2","4","6","8"]
    NOT_EDGE = ["1","3","5","7","9"]

    def move(board)
      if (board.turn_count == 0) #X
        computer_move = play_position(NOT_EDGE,board)
      end
      if (board.turn_count == 1) #O
        if board.valid_move?("5")
          computer_move = play_position(CENTER,board)
        else
          computer_move = play_position(CORNER,board)
        end # if/else
      end # if
      ############## BEGIN REPLACE WITH SIMULATION??? #########################
      if (board.turn_count == 2) #X
        # binding.pry
        if CORNER.detect { | position | board.cells[position.to_i] == (opponent(board)) } ############ THIS NEEDS FIXED!!
          computer_move = play_position(CORNER,board)
        elsif board.valid_move?("5")
          computer_move = play_position(CENTER,board)
        else
          check_for_tictac(board)                     # this should be the corner that forms a diagonal
          if !@diagonal_combo.empty?
            computer_move = play_win_or_block(diagonal_combo,board)
          else
            computer_move = play_position(CORNER,board)
          end # if/else
        end # if/elsif/else
      end # if
      if (board.turn_count > 2)
        check_for_tictac(board)
        # binding.pry
        if !@winning_combo.empty?
          #play winning_combo
          computer_move = play_win_or_block(winning_combo[0],board)
        elsif !@blocking_combo.empty?
          #play blocking_combo
          puts "Can't get that cheese by me, meat!"
          computer_move = play_win_or_block(blocking_combo,board)
        else
          computer_move = available(board).sample.to_s #Random move - fallback if all else fails
        end #if/elsif/else
      end # if
      computer_move
    end # #move(board)
    ############## END REPLACE WITH SIMULATION??? #########################

    def check_for_tictac(board)
      @winning_combo = []
      @blocking_combo = []
      Game::WIN_COMBINATIONS.each do | combo |
        check_board = []
        combo.each do | slot |
          check_board << board.cells[slot]
        end
        if check_board.count(" ") == 1 # 2 of the 3 positions in the combo have been played
          if check_board.count(self.token) == 2 # 2 were played by the current player
            @winning_combo << combo
          elsif  check_board.count("X") == 2 || check_board.count("O") == 2 # 2 were played by the opponent
            @blocking_combo = combo
          elsif (combo == [0,4,8] || combo == [2,4,6]) && check_board.count("X") == 1 && check_board.count("O") == 1
            @diagonal_combo = combo
          end #if/elsif
        end #if
      end #WIN_COMBINATIONS.each
    end #check_for_tictac

    def update_turn(board)
      @current_player == "X" ? "O" : "X"
    end

    def opponent(board)
      board.turn_count.even? ? "O" : "X"
    end

    def play_position(input,board)
      y = input.sample
      board.valid_move?(y) ? y : play_position(input,board)
    end

    def play_win_or_block(combo, board)
      computer_move = combo.detect { | board_index | board.valid_move?(board_index.to_i+1) }
      computer_move = computer_move.to_i+1
    end

    def available(board)
      @available = []
      board.cells.each.with_index do | position, index |
        if board.valid_move?( index + 1 )
          @available << ( index + 1 ).to_s
        end
      end
      @available
    end

    def find_trap(board)
      check_for_tictac(board)
      if winnable_combo.count == 2 ## NEED TO CHANGE CHECK_TICTAC TO COUNT OCCURRENCES
        computer_move = element
      end
    end

    def avoid_trap(potential_moves) ##REMOVE MOVES THAT RESULT IN THE PLAYER BEING TRAPPED FROM LIST OF POSSIBLES
      ##Remove move from potential_moves
    end

    def simulate_game(board) ##RECURSIVE METHOD TO SIMULATE FUTURE GAME PLAY AND SELECT MOVE
      potential_moves = available(board)
      @current_player = self.token
      available(board).each do | element |
        temp_board = board
        temp_board.cells[element.to_i - 1] = @current_player
        check_for_tictac(temp_board)
        find_trap(temp_board)
        ##if current token != self.token, avoid_trap
        #series of ifs here - check each move criterion and set computer_move based on priority
        #remove element from potential_moves if avoid_trap
        #else = simulate_game(temp_board)
        update_turn(temp_board)
      end
    end

  end # Class Computer

end # Module Players
