# app/models/submission.rb
class Submission < ApplicationRecord
  belongs_to :employee
  has_many :answers, dependent: :destroy

  validates :responded_at, presence: true
end
