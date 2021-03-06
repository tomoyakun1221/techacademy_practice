class ApplicationController < ActionController::Base
  include SessionHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}

  # ページ出力前に1ヶ月分のデータの存在を確認・セットします。
  def set_one_month
    @first_day = params[:date].nil? ?
                 Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入します。
    # ユーザーに紐付く一ヶ月分のレコードを検索し取得します。
    if params[:user_id].present?
      @attendances = User.find(params[:user_id]).attendances.where(date: @first_day..@last_day).order(:date)
    else
      @attendances = User.find(params[:id]).attendances.where(date: @first_day..@last_day).order(:date)
    end

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
        # 繰り返し処理により、1ヶ月分の勤怠データを生成します。
        if params[:user_id].present?
          one_month.each { |day| User.find(params[:user_id]).attendances.create!(date: day) }
        else
          one_month.each { |day| User.find(params[:id]).attendances.create!(date: day) }
        end
      end
    end

  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました、再アクセスしてください。"
    redirect_to root_url
  end

  # ログイン済みのユーザーか確認します。
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
 
  # アクセスしたユーザーが現在ログインしているユーザーか確認します。
  def correct_user
    redirect_to root_url unless current_user?(@user)
  end
 
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  # 管理者権限を持っているユーザーは勤怠の編集ができない。現在ログイ��しているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:id])
    if current_user.admin?
      flash[:danger] = "編集・操作権限がありません"
      redirect_to root_url
    end
    
    unless current_user?(@user)
      flash[:danger] = "編集・操作権限がありません"
      redirect_to root_url
    end
  end

  protect_from_forgery with: :exception
end
