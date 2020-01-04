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
