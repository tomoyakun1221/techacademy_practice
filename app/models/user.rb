class User < ApplicationRecord
  include SessionHelper
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :uid, presence: true
  validates :password, presence: true
  has_secure_password
  enum role: { general: 0, superior: 1, admin: 2 }
  
  has_many :attendances, dependent: :destroy
  has_many :change_approvals, dependent: :destroy
  has_many :overtime_approvals, dependent: :destroy
end
