class ChannelsController < ApplicationController
  # ログインしてるユーザーのみアクセス許可
  before_action :require_login, only: [:search, :create, :index]

  def index
    add_breadcrumb('お気に入りのチャンネル一覧')
  end

  def search
    add_breadcrumb('チャンネルを探す')
  end

  def create
  end
end
