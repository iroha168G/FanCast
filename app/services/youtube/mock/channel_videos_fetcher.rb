require "ostruct"

module Youtube
  module Mock
    class ChannelVideosFetcher
      STATUSES = %i[live upcoming archive].freeze
      PER_STATUS = 20

      CHANNELS = [
        { id: "mock_channel_001", title: "Mock Channel 1" },
        { id: "mock_channel_002", title: "Mock Channel 2" }
      ].freeze

      def fetch(channel_id, status)
        all_videos
          .select { |v| v[:channel_id] == channel_id }
          .select { |v| v[:status].to_s == status.to_s }
          .map { |v| build_video(**v) }
      end

      private

      def all_videos
        @all_videos ||= CHANNELS.flat_map do |channel|
          STATUSES.flat_map do |status|
            build_videos_for(channel, status)
          end
        end
      end

      def build_videos_for(channel, status)
        PER_STATUS.times.map do |i|
          base = {
            id: "#{status}_#{channel[:id]}_#{i + 1}",
            channel_id: channel[:id],
            channel_title: channel[:title],
            status: status,
            title: title_for(status, i)
          }

          case status
          when :live
            base.merge(
              started_at: Time.current - rand(5..120).minutes,
              viewers: rand(300..5000)
            )
          when :upcoming
            base.merge(
              scheduled_at: Time.current + rand(1..72).hours
            )
          when :archive
            base.merge(
              started_at: Time.current - rand(1..30).days,
              duration: random_duration
            )
          end
        end
      end

      def title_for(status, index)
        case status
        when :live
          "【Live #{index + 1}】作業用BGM / 雑談"
        when :upcoming
          "【配信予定 #{index + 1}】明日やります"
        when :archive
          "【アーカイブ #{index + 1}】過去配信まとめ"
        end
      end

      def random_duration
        hours = rand(1..4)
        minutes = rand(0..59)
        format("PT%dH%dM", hours, minutes)
      end

      # 本物の Google::Apis::YoutubeV3::Video に似せる
      def build_video(
        id:,
        channel_id:,
        channel_title:,
        title:,
        started_at: nil,
        scheduled_at: nil,
        viewers: nil,
        duration: nil,
        **_
      )
        OpenStruct.new(
          id: id,
          snippet: OpenStruct.new(
            title: title,
            channel_title: channel_title,
            channel_id: channel_id,
            thumbnails: OpenStruct.new(
              high: OpenStruct.new(
                url: "https://placehold.jp/640x360.png"
              )
            )
          ),
          live_streaming_details: OpenStruct.new(
            actual_start_time: started_at,
            scheduled_start_time: scheduled_at,
            concurrent_viewers: viewers
          ),
          content_details: OpenStruct.new(
            duration: duration
          )
        )
      end
    end
  end
end