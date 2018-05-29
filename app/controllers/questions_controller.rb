class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show update]
  before_action :find_question, only: %i[show destroy update]

  def index
    @questions = Question.all
  end

  def show
    @answers = @question.answers.order(best: :desc, created_at: :desc)
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question was successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Question was successfully deleted'
    else
      flash[:alert] = "Сan not remove someone else's question"
    end
    redirect_to questions_path
  end

  def update
    if current_user.author_of?(@question)
      @question.update(question_params)
      flash[:notice] = 'Question was succesfully edited'
    else
      flash[:alert] = "You can not delete someone else's question"
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def find_question
    @question = Question.find(params[:id])
  end
end
