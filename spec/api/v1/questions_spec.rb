require 'rails_helper'

describe 'questions API' do
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }
  let!(:questions) { create_list(:question, 5, user: user) }
  let(:question) { questions.first }

  describe 'GET #index' do
    it_behaves_like "API Authenticable"

    context 'authorized' do

      before { get '/api/v1/questions/', params: { format: :json, access_token: access_token.token } }

      it_behaves_like "response successful"
      it_behaves_like "returns array size", 'questions', 5

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end

    def do_request(options = {})
      get '/api/v1/questions/', params: { format: :json }.merge(options)
    end
  end

  describe 'GET #show' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:comments) { create_list :comment, 5, commentable: question, user: user }
      let!(:attachments) { create_list :attachment, 5, attachable: question }
      let(:question) { questions.last }
      let(:comment) { comments.last }
      let(:attachment) { attachments.last }

      before { do_request(access_token: access_token.token) }

      it_behaves_like "response successful"
      it_behaves_like "returns array size", 'comments', 5, 'comments'
      it_behaves_like "returns array size", 'attachments', 5, 'attachments'

      it "attachments object contains file" do
        expect(response.body).to be_json_eql(attachment.file.to_json).at_path('attachments/0/file')
      end

      %w(id body created_at updated_at).each do |attr|
        it "comments object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
        end
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(options)
    end
  end

  describe 'POST #create' do
    it_behaves_like "API Authenticable"

    context 'authorized' do
      context 'with valid attributes' do
        it 'saves the new question in the database' do
          expect { question_create(:question) }.to change(Question, :count).by(1)
          expect(response).to be_successful
        end

        it 'returns newly created question' do
          question_create(:question)
          expect(response.body).to eq user.questions.last.to_json
        end

        it 'question is associated with the user' do
          expect { question_create(:question) }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect { question_create(:invalid_question) }.to_not change(Question, :count)
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    def question_create(attribute)
      post "/api/v1/questions", params: { question: attributes_for(attribute), format: :json, access_token: access_token.token }
    end

    def do_request(options = {})
      post "/api/v1/questions/", params: { format: :json }.merge(options)
    end
  end
end
