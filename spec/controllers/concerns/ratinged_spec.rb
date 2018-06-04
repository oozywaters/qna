require 'rails_helper'

shared_examples_for "ratinged" do

  sign_in_user
  let(:other_user) { create(:user) }

  describe 'POST #vote_up' do
    it 'user votes two times' do
      post :vote_up, params: { id: resource }
      expect(post :vote_up, params: { id: resource }).to have_http_status(:unprocessable_entity)
    end

    it "user votes for someone else's model" do
      expect { post :vote_up, params: { id: resource } }.to change(resource.ratings, :count).by(1)
    end

    it 'user votes for his model' do
      expect { post :vote_up, params: { id: other_resource } }.to_not change(other_resource.ratings, :count)
    end
  end

  describe 'POST #vote_down' do
    it 'user votes two times' do
      post :vote_down, params: { id: resource }
      expect(post :vote_down, params: { id: resource }).to have_http_status(:unprocessable_entity)
    end

    it "user votes for someone else's model" do
      expect { post :vote_down, params: { id: resource } }.to change(resource.ratings, :count).by(1)
    end

    it 'user votes for his model' do
      expect { post :vote_down, params: { id: other_resource } }.to_not change(other_resource.ratings, :count)
    end
  end

  describe 'POST #vote_reset' do
    it "user resets his vote" do
      post :vote_up, params: { id: resource }
      expect { post :vote_reset, params: { id: resource } }.to change(resource.ratings, :count).by(-1)
    end
  end
end
