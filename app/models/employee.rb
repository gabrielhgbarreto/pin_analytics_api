class Employee < ApplicationRecord
  belongs_to :department
  belongs_to :job
  has_many :submissions, dependent: :destroy

  normalizes :email, with: ->(e) { e.strip.downcase }
  normalizes :corporate_email, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :corporate_email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
