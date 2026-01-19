FactoryBot.define do
  factory :department do
    sequence(:name) { |n| "Department #{n}" }
    kind { "company" }
  end
end
