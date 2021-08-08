class ApplicationController < ActionController::Base
  include SessionHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}

  protect_from_forgery with: :exception
end