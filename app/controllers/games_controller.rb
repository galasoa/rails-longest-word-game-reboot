require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    @letters = params[:letters]
    @answer = (params[:answer] || "").upcase
    @valid_letters = valid_letters?(@answer, @letters)
    @english_word = english_word?(@answer)
    @total_score = score_check(@answer) if @valid_letters && @english_word
  end

  private

  def valid_letters?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    raw_data = open(url).read # huge string
    json = JSON.parse(raw_data) # converts string to hash object
    json['found']
  end

  def score_check(word)
    @score = word.chars.count ** 2
    @session_score = session[:score] += @score.to_i
  end
end
