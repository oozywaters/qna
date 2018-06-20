require 'rails_helper'

describe 'Profile API' do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET #me' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      before { do_request(access_token: access_token.token) }

      it_behaves_like "response successful"

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w(password encrypted_password).each do |attr|
        it "does not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end


  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:profiles) { create_list(:user, 5) }

      before { get '/api/v1/profiles/', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "response successful"

      it 'not have current profile' do
        expect(response.body).to_not include_json(me.to_json)
      end

      it 'contains profiles' do
        expect(response.body).to be_json_eql(profiles.to_json)
      end
    end

    def do_request(options = {})
      get '/api/v1/profiles/me', params: { format: :json }.merge(options)
    end
  end
end
