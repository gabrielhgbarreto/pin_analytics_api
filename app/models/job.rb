class Job < ApplicationRecord
  has_many :employees, dependent: :restrict_with_error

  validates :title, presence: true
  validates :function_name, presence: true
end
