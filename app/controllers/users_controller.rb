class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :update_index, :destroy, :show]
  before_action :set_one_month, only: [:show, :show_only]
  before_action :logged_in_user, only: [:show, :index, :edit, :update, :destroy, :overtime_application_info, :update_index]
  before_action :correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy]
  before_action :admin_or_correct_user, only: [:show]
  
  def index
    @users = User.paginate(page: params[:page]).where.not(role: 2)
  end

  def show
    unless current_user?(@user)
      redirect_back_or(root_url)
    else
      if @user.superior?
        @overtime_applications = OvertimeApproval.where(superior_id: @user.id, application_situation: "application")
        @change_applications = ChangeApproval
                               .where(superior_id: @user.id, application_situation: "application")
                               .where.not(start_time: nil, end_time: nil)
      end
    end
  end

  def show_only
    if current_user.superior?
      set_user
    else
      redirect_back_or(root_url)
    end
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render 'new'
    end
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報の更新に成功しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザー情報の更新に失敗しました。'
      render 'edit'
    end
  end
  
  def update_index
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to root_url
    else
      flash.now[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      @users = User.all
      render 'index'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = 'ユーザーを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def working_employee_list
    if current_user.admin?

      @users = Array.new
      working_employee_attendances = Attendance.where(end_time: nil).where.not(start_time: nil)
      
      working_employee_attendances.each do |wea|
        @users.push(wea.user)
      end

    else
      flash[:danger] = "閲覧権限がありません。"
      redirect_to root_url
    end
  end
  
  def import
    if File.extname(params[:file].original_filename) == ".csv"
      flash[:success] = 'CSVファイルを読み込みました'
      User.import(params[:file])
      redirect_to users_url
    else
      flash[:danger] = 'CSVファイルを選択してください'
      @users = User.all
      redirect_to users_url
    end
  end

  def overtime_application_info
    # 残業シンセーフォームに渡すデータが必要。dateによってapplobalsを探し、あればそのまま渡し、なければnewする。
    day = params[:attendance]
    @overtime_approval = attendance.overtime_approval.find_or_initialize_by(attendance_id: attendance.id)
    render 'attendances/overtime_application_info'
  end
  
  def register_start_time
    @attendance = current_user.attendances.build
    if @walkcourse.save
      flash[:success] = '時刻が登録されました。'
      redirect_to user_path(@user)
    else
      flash.now[:danger] = '時刻の登録に失敗しました。'
      render 'show'
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :uid, :password, :password_confirmation, :role)
  end
  
  def set_user
    @user = User.find(params[:id])
  end
  
  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
    @user = User.find(params[:user_id]) if @user.blank? 
    unless current_user.admin? || current_user?(@user)
      flash[:danger] = "編集・操作権限がありません"
      redirect_to root_url
    end
  end
end
