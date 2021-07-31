class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :uid, presence: true
  validates :password, presence: true
  validate :role, presence: true
  has_secure_password
  enum role: { general: 0, superior: 1, admin: 2 }
end
