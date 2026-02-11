module Youtube
  class VideoStatusFilter
    def self.filter(videos, status)
      case status
      when "live"
        videos.select do |v|
          v.live_streaming_details&.actual_start_time.present? &&
          v.live_streaming_details&.actual_end_time.nil?
        end

      when "upcoming"
        videos.select do |v|
          v.live_streaming_details&.scheduled_start_time.present? &&
          v.live_streaming_details&.actual_start_time.nil?
        end

      when "archive"
        videos.select do |v|
          v.live_streaming_details&.actual_end_time.present?
        end

      else
        videos
      end
    end
  end
end
