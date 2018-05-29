require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let!(:question) { create(:question, user: @user) }
  let!(:answer) { create(:answer, question: question, user: @user) }

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves the new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'answer is associated with the user' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(@user.answers, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end

      # it 're-renders new view' do
      #   post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }
      #   expect(response).to render_template :show
      # end

      it 'render create template' do
        post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js
        expect(response).to render_template :create
      end

    end
  end

  describe 'PATCH #update' do
    let(:answer) { create(:answer, question: question, user: @user) }

    it 'assigns the requested answer to @answer' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'assigns th question' do
      patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
      expect(assigns(:question)).to eq question
    end

    it 'changes answer attributes' do
      patch :update, params: { id: answer, question_id: question, answer: { body: 'new body'} }, format: :js
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
      expect(response).to render_template :update
    end
  end

  describe 'DELETE #destroy' do
    context 'user tries to delete own answer' do
      it 'delete answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context "user tries to delete someone else's answer" do
      let!(:another_user) { create(:user) }
      let!(:another_answer) { create(:answer, user: another_user, question: question) }

      it 'delete answer' do
        expect { delete :destroy, params: { id: another_answer } }.to_not change(Answer, :count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: another_answer }
        expect(response).to redirect_to question_path(another_answer.question)
      end
    end
  end
end
