class Company < ApplicationRecord
  has_many :registrations
  has_many :users, through: :registrations
  #validates :url, presence: true
  validates :name, presence: true
  include PgSearch::Model

  pg_search_scope :search,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true }
                  }
end
