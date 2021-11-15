require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def generate_letter
    new_character = ('a'...'z').to_a.sample
  end

  def generate_grid
    grid_array = []
    10.times { grid_array << generate_letter }
    grid_array
  end

  def included?(word, letters)
    word.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def messages(is_word, match, chosen_word, word, letters)
    if is_word == false
      "It seems the word '#{word}' doesn't exist in english vocabulary"
    elsif match
      "Yes you can build the word '#{word}' with #{letters} and your score is #{chosen_word.count * chosen_word.count}"
    else
      "Sorry you can't build the word'#{word}' with the letters #{letters}"
    end
  end

  def get_results(word, letters)
    is_word = english_word?(word)
    chosen_word = word.chars
    chosen_letters = letters.delete(' ').chars
    match = included?(chosen_word, chosen_letters)
    messages(is_word, match, chosen_word, word, letters)
  end

  def new
    @letters = generate_grid
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    @message = get_results(@word, @letters)
  end
end
