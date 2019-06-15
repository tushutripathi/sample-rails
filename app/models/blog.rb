class Blog < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :slug, presence: true, uniqueness: true
  before_validation(on: :create) do
    self.slug = SecureRandom.hex(8)
  end
end
