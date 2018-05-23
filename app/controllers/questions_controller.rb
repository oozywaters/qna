class QuestionsController < ApplicationController
  before_action :find_question, only: %i[show]

  def index
    @questions = Question.all
  end

  def show

  end

  private

  def find_question
    @question = Question.find(params[:id])
  end
end
