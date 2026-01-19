FactoryBot.define do
  factory :employee do
    association :department
    association :job
    sequence(:name) { |n| "Employee #{n}" }
    sequence(:corporate_email) { |n| "employee#{n}@company.com" }
    tenure { "less_than_one_year" }
  end
end
