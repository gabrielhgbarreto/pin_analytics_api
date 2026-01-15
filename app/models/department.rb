class Department < ApplicationRecord
  has_ancestry

  has_many :employees, dependent: :restrict_with_error

  validates :name, presence: true
end
