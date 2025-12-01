class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:notice] = "パスワード再設定用のメールを送信しました。"
      redirect_to root_url
    else
      flash.now[:error] = "メールアドレスが存在しません"
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, "パスワードを入力してください")
      render :edit, status: :unprocessable_entity
    else
      # reset_password! を使って更新
    end
    if @user.reset_password!(params[:user][:password])
      flash[:notice] = "パスワードが更新されました"
      redirect_to login_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # ユーザーIDで取得
  def get_user
    @user = User.find_by(id: params[:id])
  end

  # ユーザー認証（存在していてトークン一致か）
  def valid_user
    token = params[:token]
    unless @user && @user.authenticated?(token)
      redirect_to root_url
    end
  end

  # トークン期限チェック
  def check_expiration
    unless @user.reset_token_valid?
      flash[:error] = "パスワード再設定の期限が切れています"
      redirect_to new_password_reset_url
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
