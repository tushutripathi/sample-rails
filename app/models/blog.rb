class Blog < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  before_validation(on: :create) do
    self.slug = SecureRandom.hex(8)
  end
  scope :from_date, ->(date) { where("created_at >= ?", date.beginning_of_day) }
  scope :to_date, ->(date) { where("created_at <= ?", date.end_of_day) }
end
