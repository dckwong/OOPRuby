class InvalidMove < RuntimeError; end
class Board
	LINES = [[[0,0],[0,1],[0,2]],[[1,0],[1,1],[1,2]],[[2,0],[2,1],[2,2]],[[0,0],[1,0],[2,0]],[[0,1],[1,1],[2,1]],
	[[0,2],[1,2],[2,2]],[[0,0],[1,1],[2,2]],[[0,2],[1,1],[2,0]]]
	attr_reader :playing
	def initialize
		@board = [[],[],[]]
		@playing = true
	end


	public
	def play_game 
		while @playing
			get_move(false)
			break unless @playing
			get_move(true)
		end
	end

	private
	def get_move player2=(false)
		puts player2 ? "Player 2's turn!" : "Player 1's turn!"
		puts "Please enter a row followed by a column in the following format {row,col} from 0 to 2. Ex: 0,2"
		begin
			move = gets.chomp.split(",")
			move.map! { |dim|  dim.to_i }
			raise InvalidMove if (!move[0].between?(0,2) || !move[1].between?(0,2) || is_filled?(move[0],move[1]))
			set_move(move[0],move[1],player2)
		rescue StandardError || InvalidMove
			puts "Invalid move! Select row,col from 0 to 2"
			retry	
		end
	end

	def is_filled? row,col
		@board[row][col]
	end

	def show_board
		for i in (0..2)
			for j in (0..2)
				print j==2 ?  "#{@board[i][j] ? " "+@board[i][j] + "\n" : "\n" }" : " #{@board[i][j] ? @board[i][j] : ' ' } |"
			end
			puts i==2 ? " " : "_________"
		end
	end

	def set_move row,col,player2=(false)
		@board[row][col] = player2 ? "o" : "x"
		show_board
		if check_win?(player2)
			puts player2 ? "Player 2 Won!" : "Player 1 Won!"
			@playing = false
		end
	end

	def check_win? player2=(false)
		check = player2 ? "o" : "x"
		for i in (0..7)
			filled = 0
			for j in (0..2)
				if @board[LINES[i][j][0]][LINES[i][j][1]] == check
					filled +=1
				end
			end
			if filled == 3
				return true
			end
		end
		false
	end
end


b = Board.new
b.play_game