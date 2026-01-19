class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :job
  has_many :submissions, dependent: :destroy

  enum :tenure, {
    less_than_one_year: 1,
    one_to_two_years: 2,
    two_to_five_years: 3,
    more_than_five_years: 4
  }

  CSV_TENURE_MAPPING = {
    'menos de 1 ano'   => 1,
    'entre 1 e 2 anos' => 2,
    'entre 2 e 5 anos' => 3,
    'mais de 5 anos'   => 4
  }.freeze

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :corporate_email, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :corporate_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
