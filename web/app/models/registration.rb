class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :company

  has_many :messages
  validates :status, presence: true
  validates :user_id, presence: true
  validates :company_id, presence: true
  STATUSES = ["unregistered", "registered", "rejected", "canceled"]
end
