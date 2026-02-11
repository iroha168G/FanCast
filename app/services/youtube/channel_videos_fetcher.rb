module Youtube
  class ChannelVideosFetcher
    CACHE_EXPIRES = {
      "live"     => 60.minutes,
      "upcoming" => 60.minutes,
      "archive"  => 12.hours
    }.freeze

    DEFAULT_EXPIRES = 30.minutes

    def initialize(youtube_service:)
      @youtube = youtube_service
    end

    def fetch(channel_id, status)
      status = status.to_s
      key = cache_key(channel_id, status)

      # ===== デバッグ用（キャッシュ確認）=====
      if Rails.cache.exist?(key)
        Rails.logger.warn("CACHE HIT: #{key}")
      else
        Rails.logger.warn("CACHE MISS: #{key}")
      end
      # =======================================

      Rails.cache.fetch(
        key,
        expires_in: CACHE_EXPIRES.fetch(status, DEFAULT_EXPIRES)
      ) do
        Rails.logger.warn("API CALL: #{channel_id} / #{status}")
        fetch_by_event(channel_id, event_type(status))
      end
    rescue Google::Apis::ClientError => e
      Rails.logger.warn("YouTube error #{status}: #{e.message}")
      []
    end

    private

    def fetch_by_event(channel_id, event_type)
      Rails.logger.warn("FETCH BY EVENT: #{channel_id} / #{event_type}")

      search =
        @youtube.list_searches(
          "snippet",
          type: "video",
          channel_id: channel_id,
          event_type: event_type,
          order: "date",
          max_results: 15
        )

      ids = search.items.map { |v| v.id.video_id }
      return [] if ids.empty?

      @youtube
        .list_videos(
          "snippet,liveStreamingDetails",
          id: ids.join(",")
        )
        .items
    end

    def event_type(status)
      case status
      when "live"     then "live"
      when "upcoming" then "upcoming"
      when "archive"  then "completed"
      else "live"
      end
    end

    def cache_key(channel_id, status)
      "youtube:channel:videos:#{status}:#{channel_id}"
    end
  end
end
