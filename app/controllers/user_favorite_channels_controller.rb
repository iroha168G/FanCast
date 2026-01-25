class UserFavoriteChannelsController < ApplicationController
  before_action :require_login

  def create
    channel = Channel.find_or_create_by!(
      platform: :youtube,
      channel_identifier: params[:channel_identifier]
    ) do |ch|
      ch.name = params[:name]
      ch.thumbnail_url = params[:thumbnail_url]
    end

    UserFavoriteChannel.find_or_create_by!(
      user: current_user,
      channel: channel
    )

    redirect_to channels_search_path(keyword: params[:channel_identifier])
  end

  def destroy
    favorite = current_user.user_favorite_channels.find(params[:id])
    favorite.destroy
    
    redirect_back fallback_location: root_path
  end
end
