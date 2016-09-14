require 'csv'

$dictionary = CSV.open '5desk.txt'

$correct_guesses = []
$incorrect_guesses = []
$guessed_letters = []
$guess_count = 0
$correctly_guessed_progress = []

def dictionary_to_array(dictionary)
  array = []
  dictionary.each do |word| 
  	if word[0].length > 4 && word[0].length < 13
  	  array << word[0].downcase
  	end
  end
  return array
end

def randomly_select_word(words)
	index = rand(0..(words.length))
	word = words[index].to_s
end

def display(word)
	length = word.length
	length.times {print "_ "}
	puts ""
end

def initiate
	puts "\n\n\n\n~~~~You're now playing Hangman! by Dominik Johnson Goj~~~~"
	print "Press 1 to start a new game or Press 2 to load an existing game: "
	choice = gets.chomp
	if choice.to_i == 1
		new_game
	elsif choice.to_i == 2
		puts "Please enter the name of the file: "
		filename = gets.chomp
		load_game(filename)
	end
end

def new_game
	words = dictionary_to_array($dictionary)
	word = randomly_select_word(words)
	$guess_length = word.length
	play(word)
end

def resume_game
	play($word)
end

def play(word)
	#puts "The randomly selected word is #{word}"
	display_letter(word)
	$guess_length = word.length
	while $guess_count < 6 && check_win(word) == false
		move(word)
		print " | The correctly guessed letters so far are: #{$correct_guesses.join(" ")}"
		puts " | The incorrectly guessed letters so far are: #{$incorrect_guesses.join(" ")}"
	end
	puts "The word was #{word}"
end

def display_letter(word,letter=false)
	split_word = word_split_to_array(word)	
		$correctly_guessed_progress = [] 
		for i in 0..(word.length - 1)
			if $guessed_letters.join("").include? split_word[i]
				print "#{split_word[i]} "
				$correctly_guessed_progress << split_word[i]
			else print "_ "
			end
		end
	print " | #{$guess_count}/6 guesses used"
end

def move(word)
	print "\nPlease guess with a letter, or type 'save' to save your game: "
	guess = gets.chomp.downcase.split("")
	if guess.length > 1
		save_game(word)
	else		
	$guessed_letters << guess
	check_guess_contains_letter(word,guess)
	end
end

def check_guess_contains_letter(word,guess)
	if word_split_to_array(word).include?(guess.join(""))
	  display_letter(word,guess)
	  $correct_guesses << guess
	else 
	  $guess_count += 1
	  display_letter(word,guess)
	  $incorrect_guesses << guess
	end
end

def check_win(word)
	if $correctly_guessed_progress.join("") == word
		puts "YOU WON!!!"
		return true
	else 
		return false
	end
end

def word_split_to_array(word)
	word.split("")
end

def save_game(word)
	puts "What would you like name your file: "
	filename = "#{gets.chomp}.txt"
	File.open(filename,'w') do |file|
		file.print "#{word}\n#{$correct_guesses}\n#{$incorrect_guesses}\n#{$guessed_letters}\n#{$guess_count}\n#{$correctly_guessed_progress}"
	end
end

def load_game(filename)
	contents = File.readlines "#{filename}.txt"
		$word = contents[0]
		$correct_guesses = Array(contents[1])
		$incorrect_guesses = Array(contents[2])
		$guessed_letters = Array(contents[3])
		$guess_count = contents[4].to_i
		$correctly_guessed_progress = Array(contents[5])
	play($word)
end

initiate




