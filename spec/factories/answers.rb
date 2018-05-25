FactoryBot.define do
  sequence :body do |n|
    "MyText#{n}"
  end

  factory :answer do
    body "MyText"
    question nil
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
