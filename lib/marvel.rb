require_relative 'character'
require_relative 'api'
require_relative 'const'
require "tty-prompt"

api = MarvelAPI.new
characters = api.get_characters

def is_magic_word(word)
  return MAGIC_WORDS.include? word
end

def create_restart_message
  str = "\n\n#################################\n"\
        "#################################\n"\
        "RESTARTING GAME\n"\
        "---------------------------------\n"\
        "1 or more characters missing desc\n"\
        "#################################\n"\
        "#################################\n\n"
  puts str
end

def create_tie_message
  str = "\n\n#################################\n"\
        "#################################\n"\
        "RESTARTING GAME\n"\
        "---------------------------------\n"\
        "IT WAS A TIE!\n"\
        "#################################\n"\
        "#################################\n\n"
  puts str
end

def create_win_message(character) 
  str = "\n\n#################################\n"\
        "#################################\n"\
        "#{character.name} WINS!!\n"\
        "#################################\n"\
        "#################################\n\n"
  puts str
end

has_winner = false

while !has_winner
  prompt = TTY::Prompt.new
  name_list = []
  characters.each_with_index {|val, index| name_list << val.create_choice_arr(index)}
  char_choices = prompt.multi_select('Choose 2 Marvel Characters', name_list)
  seed_number = prompt.ask("Provide seed number in range: 0-9?") { |q| q.in('0-9') }

  char_1 = characters[char_choices[0]]
  char_2 = characters[char_choices[1]]

  word_1 = char_1.get_word_from_seed(seed_number.to_i)    
  word_2 = char_2.get_word_from_seed(seed_number.to_i)

  if word_1 and word_2
    if is_magic_word(word_1)
      create_win_message(char1)
      has_winner = true
      break
    elsif is_magic_word(word_2)
      create_win_message(char_2)
      has_winner = true
      break
    elsif is_magic_word(word_1) and is_magic_word(word_2)
      create_tie_message()
    end

    if word_1.length > word_2.length
      create_win_message(char_1)
      has_winner = true
      break
    elsif word_2.length > word_1.length
      create_win_message(char_2)
      has_winner = true
      break
    end
  end
  create_restart_message()
end