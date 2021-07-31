class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :uid, presence: true
  validates :password, presence: true
  has_secure_password
end
