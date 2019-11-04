class Point < ApplicationRecord
  validates :point_number, presence: true
  validates :point_name, presence: true
  validates :point_type, presence: true
end
