FactoryBot.define do
  factory :job do
    sequence(:title) { |n| "Job Title #{n}" }
    sequence(:function_name) { |n| "Function #{n}" }
  end
end
