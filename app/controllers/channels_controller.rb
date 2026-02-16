class ChannelsController < ApplicationController
  # ログインしてるユーザーのみアクセス許可
  before_action :require_login, only: [ :search, :create, :index ]

  def index
    # パンくず
    add_breadcrumb("お気に入りのチャンネル一覧")
    @channels = []

    favorites = current_user.user_favorite_channels.includes(:channel)

    @channels = favorites.map do |favorite|
      channel = favorite.channel

      {
        id: channel.id,
        name: channel.name,
        thumbnail_url: channel.thumbnail_url,
        favorite_id: favorite.id,
        channel_identifier: channel.channel_identifier,
        platform: channel.platform
      }
    end

    apply_keyword_filter!
  end

  def search
    # パンくず
    add_breadcrumb("チャンネルを探す")
    @channels = []

    # ID入力がなければ何もしない
    return unless params[:keyword].present?
    channel_id = params[:keyword].strip

    # Youtube ID形式チェック
    # UC + 英数字/ハイフン/アンダースコア（24文字以上）
    unless channel_id.match?(/\AUC[a-zA-Z0-9_-]{22}\z/)
      flash.now[:alert] = "チャンネルIDの形式が正しくありません。"
      return
    end

    youtube = Rails.application.config.youtube_service

    # channels.list(1 unit)
    response = youtube.list_channels(
      "snippet,statistics",
      id: channel_id
    )

    # ヒットなし
    return if response.items.blank?

    # Viewで使用する情報
    @channels = response.items.map do |c|
      db_channel = Channel.find_by(
        platform: :youtube,
        channel_identifier: c.id
      )

      favorite = current_user.user_favorite_channels
        .find_by(channel_id: db_channel.id) if db_channel
      {
        channel_id: c.id,
        title: c.snippet.title,
        description: c.snippet.description,
        icon: c.snippet.thumbnails&.medium&.url,
        subscribers: c.statistics.hidden_subscriber_count ? nil : c.statistics.subscriber_count.to_i,
        url: "https://www.youtube.com/channel/#{c.id}",
        db_id: db_channel&.id,
        favorite_id: favorite&.id
      }
    end

  rescue Google::Apis::ClientError => e
    Rails.logger.warn("YouTube API error: #{e.message}")
    # ユーザーには「ヒットなし」に見せる
    @channels = []
  end

  def create
  end

  private

  def apply_keyword_filter!
    return unless params[:keyword].present?

    keyword = params[:keyword].downcase

    @channels.select! do |channel|
      channel[:name]&.downcase&.include?(keyword)
    end
  end
end
