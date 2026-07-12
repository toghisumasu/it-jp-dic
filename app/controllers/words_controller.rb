class WordsController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @words = @query.present? ? Word.search(@query) : Word.none
  end

  def show
    @word = Word.find(params[:id])
  end
end
