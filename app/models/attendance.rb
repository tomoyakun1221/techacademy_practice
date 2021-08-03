class Attendance < ApplicationRecord
  belongs_to :user
  has_one :change_approval, dependent: :destroy
  has_one :overtime_approval, dependent: :destroy
end
