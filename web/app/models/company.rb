class Company < ApplicationRecord
  has_many :registrations
  has_many :users, through: :registrations
  validates :url, presence: true
  validates :name, presence: true
  has_one_attached :tos_document
end
