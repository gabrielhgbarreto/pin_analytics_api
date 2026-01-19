FactoryBot.define do
  factory :answer do
    association :submission
    association :question
    score_value { 10 }
  end
end
