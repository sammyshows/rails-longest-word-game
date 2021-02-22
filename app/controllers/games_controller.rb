require 'open-uri'

class GamesController < ApplicationController

  def new
    # TODO: generate random grid of letters
    @letters = (1..10).map { rand(65..90).chr }
  end

  def score
    @start_time = Time.now
    @attempt = params["answer"]
    @end_time = Time.now
    # def run_game(@attempt, grid, start_time, end_time)
    result = {}
    result[:time] = (@end_time - @start_time)
    verifier = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{@attempt}").read)["found"]
    if verifier && grid_verifier(@attempt, LETTERS)
      verified_true(result, result[:time], @attempt)
    else
      verified_false(result, verifier)
    end
    @result = result
  end

  def grid_verifier(attempt, grid)
    @attempt = @attempt.upcase.chars
    @attempt.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
  end

  def verified_true(result, time_taken, attempt)
    result[:message] = "Well done! You found a word!"
    result[:score] = 2000 - time_taken * 200 + 500 * @attempt.length
  end

  def verified_false(result, verifier)
    result[:score] = 0
    if verifier == true
      result[:message] = "not in the grid"
    else
      result[:message] = "not an english word"
    end
  end
end
