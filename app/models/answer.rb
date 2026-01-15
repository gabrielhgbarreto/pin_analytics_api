class Answer < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  validate :validate_value_presence

  private

  def validate_value_presence
    if score_value.blank? && text_value.blank?
      errors.add(:base, "A resposta precisa conter um valor")
    end
  end
end
