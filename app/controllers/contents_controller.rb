class ContentsController < ApplicationController
  def index
    youtube = Rails.application.config.youtube_service

    live_videos = Rails.cache.fetch("live_videos", expires_in: 60.minutes) do
      # 配信中の動画を検索
      search_response = youtube.list_searches(
        "snippet",
        event_type: "live",
        type: "video",
        q: "作業用BGM",
        max_results: 50
      )

      video_ids = search_response.items.map { |v| v.id.video_id }.join(",")

      # 動画の詳細情報を取得
      youtube.list_videos("snippet,liveStreamingDetails", id: video_ids).items
    end

    # まとめてチャンネルIDを取得
    channel_ids = live_videos.map { |v| v.snippet.channel_id }.uniq

    # チャンネル情報取得
    channel_response = youtube.list_channels("snippet", id: channel_ids.join(","))
    channel_icons = channel_response.items.index_by(&:id).transform_values do |c|
      c.snippet.thumbnails&.default&.url
    end

    # 動画 + チャンネルアイコンを紐付け
    @videos = live_videos.map do |video|
      {
        title: video.snippet.title,
        video_id: video.id,
        video_thumbnail: video.snippet.thumbnails&.high&.url,
        channel_title: video.snippet.channel_title,
        channel_id: video.snippet.channel_id,
        channel_icon: channel_icons[video.snippet.channel_id],
        live_starttime: video.live_streaming_details&.actual_start_time,
        live_viewers: video.live_streaming_details&.concurrent_viewers
      }
    end

    # ランダムに20件表示
    @videos = @videos.sample(20)

    # 日付順に並べ替え（昇順: 古い順 / 降順: 新しい順）
    @videos = @videos.sort_by { |video| video[:live_starttime] }.reverse
  end
end
