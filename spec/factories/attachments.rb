FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
    question nil
    answer nil
  end
end
