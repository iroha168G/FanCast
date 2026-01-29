module Youtube
  class ChannelLiveFetcher
    CACHE_EXPIRES_IN = 30.minutes

    def initialize(youtube_service:)
      @youtube = youtube_service
    end

    # チャンネルID1つ分の配信動画を取得
    def fetch(channel_id)
      Rails.cache.fetch(cache_key(channel_id), expires_in: CACHE_EXPIRES_IN) do
        fetch_from_youtube(channel_id)
      end
    end

    private

    def cache_key(channel_id)
      "youtube:channel_live_videos:#{channel_id}"
    end

    def fetch_from_youtube(channel_id)
      search_response = @youtube.list_searches(
        "snippet",
        event_type: "live",
        type: "video",
        channel_id: channel_id,
        max_results: 10
      )

      video_ids = search_response.items.map { |v| v.id.video_id }
      return [] if video_ids.empty?

      @youtube.list_videos(
        "snippet,liveStreamingDetails",
        id: video_ids.join(",")
      ).items
    end
  end
end
