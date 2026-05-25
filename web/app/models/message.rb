class Message < ApplicationRecord
  belongs_to :registration
  validates :content, presence: true
  validates :role, presence: true
  validates :registration_id, presence: true
end
