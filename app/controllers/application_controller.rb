class ApplicationController < ActionController::Base
  # Helperのメソッドをcontrollerでも使えるように読み込む
  include SessionsHelper

  before_action :set_breadcrumbs

  # Viewでもメソッドを使用可能にする
  helper_method :current_user, :logged_in?

  # DBからuserを探す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  #ログインの有無
  def logged_in?
    current_user.present?
  end

  #ログインしてない場合
  def require_login
    unless logged_in?
      redirect_to login_path, alert: "ログインしてください。"
    end
  end

  private
  
  #パンくずを配列に追加
  def add_breadcrumb(label, path = nil)
    @breadcrumbs << {
      label: label,
      path: path
    }
  end

  def set_breadcrumbs
    @breadcrumbs ||= []
    @breadcrumbs << { label: "Home", path: root_path }
  end
end
