require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions) }
  it { should have_many(:answers) }
  it { should have_many(:comments) }

  describe '#admin?' do
    let(:user) { create(:user) }
    let(:admin) { create(:admin) }

    it 'return false for not admin' do
      expect(user.admin?).to be_falsey
    end

    it 'return true for admin' do
      expect(admin.admin?).to be_truthy
    end
  end

  describe "#author_of?(resource)" do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "user is the author" do
      expect(user).to be_author_of(question)
    end
    it "user is not an author" do
      expect(another_user).not_to be_author_of(question)
    end
  end

  describe '#temp_email?' do
    let(:user) { create(:user) }
    let(:temp_email_user) { create(:user, email: '123@temp.email') }

    it 'the user has a temporary email' do
      expect(temp_email_user.temp_email?).to be_truthy
    end

    it 'the user has a verify email' do
      expect(user.temp_email?).to be_falsey
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }
        it 'does not create new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it 'creates authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
