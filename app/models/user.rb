class User < ApplicationRecord
  has_many :attendances, dependent: :destroy
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  
  validates :name, presence: true, length: { maximum: 50 }
  validates :department, length: { in: 2..30 }, allow_blank: true
  validates :basic_time, presence: true
  validates :work_time, presence: true
  validates :employee_number, presence: true, uniqueness: true
  validates :user_card_id, presence: true, uniqueness: true
  validates :user_designated_work_start_time, presence: true
  validates :user_designated_work_end_time, presence: true

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 }, 
  format: { with: VALID_EMAIL_REGEX }, 
  uniqueness: true

  has_secure_password
  
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  enum decision: { "なし" => 1, "申請中" => 2, "承認" => 3, "否認" => 4 }
  
  # 上長一覧(自分が上長の場合、自分を除く)
  def User.superior_user_list_non_self(session)
    if User.find(session[:user_id]).superior == true
      where(superior: true).where.not(id: session[:user_id])
    else
      where(superior: true)
    end
  end
  
  
  # ーーーーーRemember関係ーーーーー
   # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = 
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end
  
  #ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64  
  end
  
  #永続セッションのユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end
  
  #記憶トークンが記憶ダイジェストと一致すればtrueを返
  def authenticate?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
  
  #ユーザーのログイン状態を破棄
  def forget
    update_attribute(:remember_digest, nil) 
  end
  
  # ユーザー名による絞り込み
  scope :get_by_name, ->(name) {
    where("name like ?", "%#{name}%")
  }
end