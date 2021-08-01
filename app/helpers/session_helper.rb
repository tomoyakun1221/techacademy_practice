module SessionHelper
  
   # 引数に渡されたユーザーオブジェクトでログインします。
  def log_in(user)
    session[:user_id] = user.id
  end
  
  #セッションとcurrent_userを破棄する
  def log_out
    # forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  #永続セッションを記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  #永続的セッションの破棄
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

   # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
   # 一時的セッションにいるユーザーを返します。
   # それ以外の場合はcookiesに対応するユーザーを返します。
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticate?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザー(user)がログイン済みのユーザー(current_user)であればtrueを返します。
  def current_user?(user)
    user == current_user
  end
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
  def logged_in?
    !current_user.nil?
  end
  
  #ログインしようとしたユーザーがログイン失敗し、再度ログインした場合にセッションに保存していたURLにすぐに遷移できるようにする
  #遷移したいあと、セッションにずっと残っていると、ログインの都度セッションに残したサイトに遷移するので、nilにする
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  #アクセスしようとしたURLを記憶する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
