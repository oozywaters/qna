require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:questions) { create_list(:question, 2) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array with all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
  end
end
