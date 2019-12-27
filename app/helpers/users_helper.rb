module UsersHelper
  def format_basic_info(time)
    format("%.2f", ((time.hour*60)+time.min) / 60.0)
  end
  
  def edit_basic_info
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  # # CSVインポート
  # def import
  #   # fileはtmpに自動で一時保存される
  #   User.import(params[:file])
  #   redirect_to users_url
  # end
  
  # def self.import(file)
  #   CSV.foreach(file.path, headers: true) do |row|
  #     # IDが見つかれば、レコードを呼び出し、見つかれなければ、新しく作成
  #     user = find_by(id: row["id"]) || new
  #     # CSVからデータを取得し、設定する
  #     user.attributes = row.to_hash.slice(*updatable_attributes)
  #     # 保存する
  #     user.save
  #   end
  # end
  
  # # 更新を許可するカラムを定義
  # def self.updatable_attributes
  #   ["id", "name", "email", "department", "employee_number", "user_card_id", "basic_time", "user_designated_work_start_time", "user_designated_work_end_time", "superior", "admin", "password"]
  # end

  
  def import
    if params[:file] && File.extname("#{params[:file].original_filename}") == ".csv"
      # 登録処理前のレコード数
      users = []
      CSV.foreach(params[:file].path, headers: true, encoding: "UTF-8") do |row|
        users << User.create({
          name:                            row['name'],
          email:                           row['email'],
          department:                      row['department'],
          employee_number:                 row['employee_number'],
          user_card_id:                    row['user_card_id'],
          basic_time:                      row['basic_time'],
          user_designated_work_start_time: row['user_designated_work_start_time'],
          user_designated_work_end_time:   row['user_designated_work_end_time'],
          superior:                        row['superior'],
          admin:                           row['admin'],
          password:                        row['password'] })
      end
      flash[:success] = "アカウントを新規作成しました。"
    else
      flash[:danger] = "CSVファイルを選択してください。"
    end
    redirect_to users_path
  end

  def basic_info_edit
  end
 
   # 所属長承認の表示(１ヶ月分)
  def current_month_status(day)
    @attendance = @user.attendances.find_by(worked_on: day)
    if @attendance.decision_month_order.to_s == "なし"
      "#{@attendance.month_order_status}:なし"
    elsif @attendance.decision_month_order.to_s == "申請中"
      "#{@attendance.month_order_id}に申請中"
    elsif @attendance.decision_month_order.to_s == "承認"
      "#{@attendance.month_order_status}から承認済"
    elsif @attendance.decision_month_order.to_s == "否認"
      "#{@attendance.month_order_status}から否認"
    else
      "未"
    end
  end
  
  #残業申請の表示
  def overtime_day_status(day)
    @attendance = @user.attendances.find_by(worked_on: day)
    if @attendance.decision.to_s == "なし"
      "#{@attendance.overtime_order_status}:なし"
    elsif @attendance.decision.to_s == "申請中"
      "#{@attendance.overtime_order_id}に申請中"
    elsif @attendance.decision.to_s == "承認"
      "#{@attendance.overtime_order_status}から承認済"
    elsif @attendance.decision.to_s == "否認"
      "#{@attendance.overtime_order_status}から否認"
    end
  end
  
  #勤怠変更申請の表示
  def attendance_change_status(day)
    @attendance = @user.attendances.find_by(worked_on: day)
    if @attendance.decision_attendance_change == "なし"
      "勤怠編集:#{@attendance.attendance_change_order_status}:なし"
    elsif @attendance.decision_attendance_change == "申請中" && @attendance.attendance_change_order_id == "上長A" || @attendance.attendance_change_order_id == "上長B" 
      "勤怠編集:#{@attendance.attendance_change_order_id}に申請中"
    elsif @attendance.decision_attendance_change == "承認"
      "勤怠編集:#{@attendance.attendance_change_order_status}から承認済"
    elsif @attendance.decision_attendance_change == "否認"
      "勤怠編集:#{@attendance.attendance_change_order_status}から否認"
    end
  end
end

