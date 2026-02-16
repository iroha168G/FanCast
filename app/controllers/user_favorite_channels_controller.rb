class UserFavoriteChannelsController < ApplicationController
  before_action :require_login

  def create
    channel = Channel.find_or_initialize_by(
      platform: :youtube,
      channel_identifier: params[:channel_identifier]
    )

    # 毎回最新情報を代入
    channel.name = params[:name]
    channel.thumbnail_url = params[:thumbnail_url]

    # 差分があれば更新
    channel.save! if channel.changed?

    favorite =
      UserFavoriteChannel.find_or_create_by!(
        user: current_user,
        channel: channel
      )

    # チャンネル単位キャッシュ削除（status別）
    delete_channel_video_caches(channel.channel_identifier)

    redirect_to channels_search_path(keyword: params[:channel_identifier]),
                notice: "チャンネルを登録しました。"
  end

  def destroy
    favorite = current_user.user_favorite_channels.find(params[:id])

    delete_channel_video_caches(favorite.channel.channel_identifier)

    favorite.destroy
    redirect_back fallback_location: root_path, notice: "チャンネルの登録を解除しました。"
  end

  private

  def delete_channel_video_caches(channel_identifier)
    %w[live upcoming archive].each do |status|
      Rails.cache.delete(
        "youtube:channel:videos:#{status}:#{channel_identifier}"
      )
    end
  end
end
