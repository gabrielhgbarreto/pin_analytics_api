FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "Question #{n}?" }
  end
end
