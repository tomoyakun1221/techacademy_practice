class PointsController < ApplicationController
  
  before_action :set_point, only: [ :edit_point_info, :update_point_info, :destroy ]
  
  def new
    @point = Point.new
  end
  
  def index
    @points = Point.all
  end
  
  def edit_point_info
  end
  
  def create
    @point = Point.new(point_params)
    if @point.save
      flash[:success] = '拠点情報の作成に成功しました。'
    else
      flash[:danger] = '入力項目に空欄があります。全てに入力して下さい。'
    end
    redirect_to points_url
  end
  
  def update_point_info
    if @point.update_attributes(point_params)
      flash[:success] = "拠点番号#{@point.point_number}の拠点情報を更新しました。"
    else
      flash[:danger] = "拠点情報を更新に失敗しました。"
    end
    redirect_to points_url
  end
  
  def destroy
    @point.destroy
    flash[:success] = "#{@point.point_name}のデータを削除しました。"
    redirect_to points_url
  end

  private

  def point_params
    params.require(:point).permit(:point_number, :point_name, :point_type)
  end

  def set_point
    @point = Point.find(params[:id])
  end
  
  # システム管理権限所有かどうか判定します。
  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
