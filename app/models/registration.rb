class Registration < ApplicationRecord
  after_save :set_registration_length

  scope :by_length, ->(length) { where(reg_length: length) }

  def set_registration_length
    self.update_columns(reg_length: self.number.length)
  end
end
