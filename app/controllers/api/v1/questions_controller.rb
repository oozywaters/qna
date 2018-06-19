class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :find_question, only: :show

  authorize_resource

  def index
    respond_with(Question.all)
  end

  def show
    respond_with(@question, serializer: QuestionShowSerializer)
  end

  def create
    @question = current_user.questions.create(question_params)
    respond_with(@question)
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
