class Product < ApplicationRecord
  validates :title, :description, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
end
