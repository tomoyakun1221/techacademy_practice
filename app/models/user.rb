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
  
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
      user = find_by(id: row["id"]) || new
      # CSVからデータを取得し、設定する
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save
    end
  end
  
  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["user_id", "uid", "name", "role", "password", "password_confirmation"]
  end
end
