FactoryBot.define do
  factory :submission do
    association :employee
    responded_at { Time.current }
  end
end
