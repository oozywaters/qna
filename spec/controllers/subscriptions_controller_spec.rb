require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  sign_in_user
  let(:other_user) { create(:user) }
  let!(:resource) { create(:question, user: other_user) }

  describe 'POST #create' do
    it 'the user subscribed to the resource' do
      expect { post :create, params: { question_id: resource } }.to change(resource.subscriptions, :count).by(1)
    end
  end

  describe 'DELETE #destroy' do
    it 'the user unsubscribed to the resource' do
      post :create, params: { question_id: resource }
      expect{ delete :destroy, params: { id: resource.subscriptions.find_by(user: @user) } }.to change(resource.subscriptions, :count).by(-1)
    end
  end
end
