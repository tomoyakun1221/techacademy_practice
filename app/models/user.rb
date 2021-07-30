class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :uid, presence: true, length: { maximum: 20 }
  validates :role, presence: true, length: { maximum: 1 }
  validates :password, presence: true
  has_secure_password
end
