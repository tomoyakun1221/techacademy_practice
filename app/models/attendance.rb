class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  enum decision:{ なし: 0, 申請中: 1, 承認: 2, 否認: 3 }
  
  # 出勤時間がなく、退勤時間がない場合、無効にする
  validate :finished_at_is_invalid_without_a_started_at
  
  # 出勤時間が退勤時間よりも遅い場合、無効にする
  # validate :form_is_invalid_when_started_at_is_longer_than_finished_at

  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
  end
  
  # def form_is_invalid_when_started_at_is_longer_than_finished_at
  #   if started_at.present? && finished_at.present?
  #     errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
  #   end
  # end
end