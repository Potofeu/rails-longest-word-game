require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = alphabet.sample(10)
  end

  def score
    @grid = params[:grid].chars
    @score = ""
    if valid_word?(params[:answer], @grid) == false
      @score = "Sorry but #{params[:answer].upcase} cant'be built out of #{@grid.join(', ')}"
    elsif existing_word?(params[:answer]) == false
      @score = "Sorry but #{params[:answer].upcase} doesn't seem to be a valid English word..."
    else
      @score = "Congratulations! #{params[:answer].upcase} is a valid English word!"
    end
  end

  private

  def existing_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    web_answer = URI.open(url).read
    result_hash = JSON.parse(web_answer)
    result = result_hash["found"]
    return result
  end

  def valid_word?(attempt, grid)
    attempt_array = attempt.upcase.chars
    attempt_array.all? { |letter| grid.include?(letter) && grid.count(letter) >= attempt_array.count(letter) }
  end
end
