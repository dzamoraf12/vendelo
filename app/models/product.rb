class Product < ApplicationRecord
  has_one_attached :photo

  validates :title, :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
