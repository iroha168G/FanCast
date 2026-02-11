class ContentsController < ApplicationController
  def index
    status = params[:status].presence || "live"

    if current_user
      videos = fetch_login_videos(status)

      if searching_keyword?
        @videos = filter_by_keyword(videos)
      else
        @videos = videos
      end

      return
    end

    # 未ログインは従来どおりランダム
    base_videos = fetch_guest_live_videos_cached
    @videos = base_videos.sample(20)
  end

  private

  # =====================================
  # ログインユーザー
  # =====================================
  def fetch_login_videos(status)
    youtube = Rails.application.config.youtube_service
    fetcher = Youtube::ChannelVideosFetcher.new(youtube_service: youtube)

    videos =
      current_user.user_favorite_channels.includes(:channel).flat_map do |favorite|
        fetcher.fetch(
          favorite.channel.channel_identifier,
          status
        )
      end

    channel_icons =
      fetch_channel_icons(
        youtube,
        videos.map { |v| v.snippet.channel_id }
      )

    normalize_videos_by_status(videos, channel_icons, status)
  rescue Google::Apis::ClientError => e
    Rails.logger.warn("YouTube quota exceeded (login): #{e.message}")
    []
  end

  def filter_by_keyword(videos)
    keyword = params[:keyword].to_s.downcase

    videos.select do |video|
      video[:title]&.downcase&.include?(keyword) ||
        video[:channel_title]&.downcase&.include?(keyword)
    end
  end

  def searching_keyword?
    params[:keyword].present? &&
      params[:keyword].strip != ""
  end

  # =====================================
  # 未ログインユーザー（liveのみ）
  # =====================================
  def fetch_guest_live_videos_cached
    fetch_guest_live_videos_base
  end

  def fetch_guest_live_videos_base
    Rails.cache.fetch("guest:live:videos:base:v1", expires_in: 30.minutes) do
      youtube = Rails.application.config.youtube_service

      search_response = youtube.list_searches(
        "snippet",
        event_type: "live",
        type: "video",
        q: "作業用BGM",
        max_results: 50
      )

      video_ids = search_response.items.map { |v| v.id.video_id }
      next [] if video_ids.empty?

      videos =
        youtube.list_videos(
          "snippet,liveStreamingDetails",
          id: video_ids.join(",")
        ).items

      channel_icons =
        fetch_channel_icons(
          youtube,
          videos.map { |v| v.snippet.channel_id }
        )

      normalize_videos(videos, channel_icons)
    end
  rescue Google::Apis::ClientError => e
    Rails.logger.warn("YouTube API error (guest videos): #{e.message}")
    []
  end

  # =====================================
  # チャンネルアイコン取得（キャッシュ付き）
  # =====================================
  def fetch_channel_icons(youtube, channel_ids)
    return {} if channel_ids.blank?

    channel_ids.uniq.each_with_object({}) do |channel_id, icons|
      icons[channel_id] =
        Rails.cache.fetch(
          "youtube:channel:icon:#{channel_id}",
          expires_in: 12.hours
        ) do
          response =
            youtube.list_channels(
              "snippet",
              id: channel_id
            )

          response.items.first&.snippet&.thumbnails&.default&.url
        end
    end
  rescue Google::Apis::ClientError => e
    Rails.logger.warn("YouTube API error (icons): #{e.message}")
    {}
  end

  # =====================================
  # 共通処理
  # =====================================
  def normalize_videos(videos, channel_icons)
    videos.map do |video|
      {
        title: video.snippet.title,
        video_id: video.id,
        video_thumbnail: video.snippet.thumbnails&.high&.url,
        channel_title: video.snippet.channel_title,
        channel_id: video.snippet.channel_id,
        channel_icon: channel_icons[video.snippet.channel_id],
        live_starttime: video.live_streaming_details&.actual_start_time,
        scheduled_starttime: video.live_streaming_details&.scheduled_start_time,
        live_viewers: video.live_streaming_details&.concurrent_viewers
      }
    end
  end

  def normalize_videos_by_status(videos, channel_icons, status)
    normalized = normalize_videos(videos, channel_icons)

    case status
    when "upcoming"
      normalized
        .select { |v| v[:scheduled_starttime].present? }
        .sort_by { |v| v[:scheduled_starttime] }
    when "archive"
      normalized
        .select { |v| v[:live_starttime].present? }
        .sort_by { |v| v[:live_starttime] }
        .reverse
    else # live
      normalized
        .select { |v| v[:live_starttime].present? }
        .sort_by { |v| v[:live_starttime] }
        .reverse
    end
  end
end
