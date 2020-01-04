require 'httparty'
require 'digester'
require 'json'
require_relative 'character'
require_relative 'const'

require "tty-prompt"

class MarvelAPI
  @@base_url = 'http://gateway.marvel.com/v1/public'
  @@private_key ='4b8aebe6f039aaee6ccdfa075b35aa1da0431c91'  
  @@public_key ='a71400acb85e13c069db34aec66f63a1' 
  @@full_url = ''
  @@time = ''
  @@hash = '' 

  def initialize()
    @@time = create_timestamp 
    @@hash = create_md5_hash()
    @@full_url = @@base_url
  end

  def create_timestamp
    return Time.now.getutc.to_i.to_s
  end
  
  def create_md5_hash
    pre_key = @@time + @@private_key + @@public_key
    return Digester::Digester.new.digest(pre_key)
  end

  def create_url(endpoint)
    return @@base_url + endpoint + '?apikey=' + @@public_key + '&ts=' + @@time + '&hash=' + @@hash
  end

  def get_characters
    url = create_url('/characters')
    response = HTTParty.get(url)
    if response.code === 200
      character_arr = []
      results = JSON.parse(response.body)
      for char in results['data']['results']
        new_char = Character.new(char)
        character_arr << new_char 
      end
      return character_arr
    end
    return false
  end

end

blah = MarvelAPI.new
characters = blah.get_characters

def is_magic_word(word)
  return MAGIC_WORDS.include? word
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
  if word_1
    print '1 - ' + char_1.get_word_from_seed(seed_number.to_i)
  else
    print 'Character 1 has no description'
  end
    
  word_2 = char_2.get_word_from_seed(seed_number.to_i)
  if word_2
    print ' 2 - ' + char_2.get_word_from_seed(seed_number.to_i)
  else
    print 'Character 2 has no description'
  end

  if word_1 and word_2
    if is_magic_word(word_1)
      print 'CHARACTER 1 GOT A MAGIC WORD! AND WINS'
      has_winner = true
    elsif is_magic_word(word_2)
      print 'CHARACTER 2 GOT A MAGIC WORD! AND WINS!'
      has_winner = true
    end
    
    if word_1.length > word_2.length
      print 'CHARACTER 1 WINS'
      has_winner = true
    elsif word_2.length > word_1.length
      print 'CHARACTER 2 WINS'
      has_winner = true
    else
      print 'its a tie start over'
    end
  end
end