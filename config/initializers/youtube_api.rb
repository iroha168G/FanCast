require "google-apis-youtube_v3"

Rails.application.config.youtube_service = Google::Apis::YoutubeV3::YouTubeService.new.tap do |youtube|
  youtube.key = ENV["YOUTUBE_API_KEY"]
end

