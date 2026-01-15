# app/models/submission.rb
class Submission < ApplicationRecord
  belongs_to :employee
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :answers

  validates :responded_at, presence: true

  before_create :capture_snapshots

  private

  def capture_snapshots
    return unless employee

    self.snapshot_org_unit_name = employee.department&.name
    self.snapshot_job_title     = employee.job&.title
  end
end
