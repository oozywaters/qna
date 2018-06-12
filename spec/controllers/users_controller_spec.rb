require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #signup_email' do
    context 'temp email' do
      sign_in_user('email@temp.email')
      it 'changes user attributes' do
        patch :signup_email, params: { id: @user, user: { email: 'new@email.com'} }
        @user.reload
        expect(@user.unconfirmed_email).to eq 'new@email.com'
      end

      it 'render update template' do
        patch :signup_email, params: { id: @user, user: { email: 'new@email.com'} }
        expect(response.location).to match(add_email_user_path(@user))
      end
    end

    context 'verify email' do
      sign_in_user
      it 'resdirect verify user' do
        patch :signup_email, params: { id: @user, user: { email: 'new@email.com'} }
        @user.reload
        expect(@user.unconfirmed_email).to_not eq 'new@email.com'
      end
    end
  end

  describe 'GET #add_email' do
    context 'temp email' do
      sign_in_user('email@temp.email')
      before { get :add_email, params: { id: @user } }

      it 'render view add_email' do
        expect(response).to render_template :add_email
      end
    end

    context 'verify email' do
      sign_in_user
      before { get :add_email, params: { id: @user } }

      it 'on the page can only get with a temporary email' do
        expect(response.location).to match(root_path)
      end
    end
  end
end
