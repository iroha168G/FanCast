class PasswordResetsController < ApplicationController
  before_action :get_user,         only: [ :edit, :update ]
  before_action :valid_user,       only: [ :edit, :update ]
  before_action :check_expiration, only: [ :edit, :update ]

  def new
  end

  # メール送信（ユーザー存在有無は隠す）
  def create
    user = User.find_by(email: params[:password_reset][:email].downcase)

    if user
      user.create_reset_digest
      user.send_password_reset_email
    end

    flash[:notice] = "パスワード再設定用のメールを送信しました。"
    redirect_to root_url
  end

  def edit
    # before_action で検証済み
  end

  def update
    unless params[:user]&.[](:password).present?
      @user.errors.add(:password, "を入力してください。")
      render :edit, status: :unprocessable_entity
      return
    end

    if @user.update(user_params.merge(reset_digest: nil, reset_sent_at: nil))
      flash[:notice] = "パスワードが更新されました。"
      redirect_to root_url
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # URLの id からユーザー取得
  def get_user
    @user = User.find_by(id: params[:id])
  end

  # トークン一致チェック
  def valid_user
    token = params[:token]

    unless @user && token.present? && @user.authenticated?(token)
      flash[:alert] = "無効なパスワード再設定リンクです。"
      redirect_to root_url
    end
  end

  # 有効期限チェック（2時間）
  def check_expiration
    return unless @user

    unless @user.reset_token_valid?
      flash[:alert] = "パスワード再設定の期限が切れています。"
      redirect_to new_password_reset_url
    end
  end
end
