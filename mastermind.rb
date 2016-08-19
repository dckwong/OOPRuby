module Tools

	def check_guess guess, code
		right_code = code.map { |col| col }
		the_guess = guess.map{ |col| col}
		score = {
			"in_right_spot" => 0,
			"right_color_wrong_spot" => 0
		}
		to_delete = []
		right_code.delete_if.with_index do |color,i|
			guess_color = the_guess[i]
			if color == guess_color
				score["in_right_spot"] +=1
				to_delete << color
			end
		end
		unless to_delete.empty?
			to_delete.each do |color| 
				the_guess.delete_at(the_guess.index(color) || the_guess.length)
			end
		end
		right_code.delete_if do |color|
			if the_guess.include?(color)
				score["right_color_wrong_spot"] +=1
				the_guess.delete_at(the_guess.index(color) || the_guess.length)
			end
		end
		score
	end

end

class Mastermind
	include Tools
	COLORS = {
		"r" => "red",
		"b" => "blue",
		"y" => "yellow",
		"g" => "green",
		"p" => "purple",
		"o" => "orange"
	}
	attr_reader :COLORS, :score, :guesses
	private
	def initialize 
		@computer = Computer.new
		@game_over = false
		@player = Player.new
		@game_mode = @player.starting_choice
		@guesses = 12
		@code = @game_mode == "codemaster" ? @player.create_code : @computer.create_code
		@score = {
			"in_right_spot" => 0,
			"right_color_wrong_spot" => 0
		}
	end

	def check_win 
		@guesses -=1
		if @score["in_right_spot"] == 4 
			@game_over = true
			puts "Guesser won!"
		elsif @guesses == 0
			@game_over = true
			puts "Code maker wins!"
		else 
			puts "You have #{@score['in_right_spot']} in the right spot"
			puts "You have #{@score['right_color_wrong_spot']} right colors, but in the wrong spot"
		end
	end

	def to_s code
		"#{code[0]}, #{code[1]}, #{code[2]}, #{code[3]}"
	end

	public
	def play_game
		if @game_mode == "codebreaker"
			until @game_over 
				puts
				guess = @player.get_guess
				@score = check_guess(guess, @code)
				check_win
			end
		elsif @game_mode == "codemaster"
			puts
			puts "Guesses left #{@guesses}"
			all_possible_values = @computer.all_possible_values
			guess = @computer.first_move
			puts "Starting guess is #{to_s(guess)}"
			@score = check_guess(guess,@code)
			check_win
			until @game_over
				puts
				puts "Guesses left #{@guesses}"
				all_possible_values = @computer.algorithm(@score["in_right_spot"],@score["right_color_wrong_spot"],all_possible_values)
				guess = @computer.moves_after(all_possible_values)
				puts "Computer guessed #{to_s(guess)}"
				@score = check_guess(guess,@code)
				check_win
			end
		end
	end

end

class InvalidGuess < Exception; end

class Player

	def initialize; end

	private
	def get_colors
		colors = gets.chomp.split(/\s+/)
		colors.each do |col|
			raise InvalidGuess unless Mastermind::COLORS.keys.include?(col)
		end
		colors.map!{ |col| Mastermind::COLORS[col]}
		colors
	end

	public
	def create_code
		begin 
			puts "Please choose the starting code of 4 of the following: r(ed), b(lue), y(ellow), g(reen), p(urple), or o(range) separated with spaces"
			code = get_colors
		rescue InvalidGuess
			puts "Not a valid starting code. First letter of each color, space separated please."
			retry
		else
			code
		end
	end

	def get_guess 
		begin
			puts "Please guess a combination of 4 of the following: r(ed), b(lue), y(ellow), g(reen), p(urple), or o(range) separated with spaces"
			guess = get_colors
		rescue InvalidGuess
			puts "Not a valid guess. First letter of each color, space separated please"
			retry
		else
			guess
		end
		
	end

	def starting_choice
		begin
			puts "Do you want to be the 'codemaster' or 'codebreaker'?"
			choice = gets.chomp
			raise InvalidGuess unless choice == "codemaster" || choice == "codebreaker"
		rescue InvalidGuess
			puts "Choose either 'codemaster' or 'codebreaker'!"
			retry
		else
			choice
		end
	end

end


class Computer
	include Tools

	def initialize 
		@guess = []
	end
	public
	def create_code 
		code = []
		4.times do 
			code << Mastermind::COLORS.values.sample
		end
		code
	end

	def all_possible_values
		set = []
		colors = Mastermind::COLORS.values
		colors.each do |color_1|
			colors.each do |color_2|
				colors.each do |color_3|
					colors.each do |color_4|
						set << [color_1,color_2,color_3,color_4]
					end
				end
			end
		end
		set
	end

	def first_move
		set = all_possible_values
		@guess = set[7]
	end

	def moves_after new_set
		@guess = new_set.sample
	end

	def algorithm right_spot_count, wrong_spot_count,set
		new_set = get_eligible_values(right_spot_count,wrong_spot_count,set)
			#remove from set any combo that does not give same response if guess were the code
		
	end

	private
	def get_eligible_values right_spot_count, wrong_spot_count, set
		code = @guess
		set.delete_if do |possible_guess|
			this_score = check_guess(possible_guess,code)
			this_score['in_right_spot'] != right_spot_count || this_score['right_color_wrong_spot'] != wrong_spot_count
		end
	end
end

game = Mastermind.new
game.play_game
