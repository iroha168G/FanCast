module Youtube
  class ChannelVideosProvider
    def initialize(user:, youtube_service:)
      @user = user
      @youtube = youtube_service
    end

    def fetch(channel_id, status)
      fetcher.fetch(channel_id, status)
    end

    private

    def fetcher
      if @user.mock?
        Youtube::Mock::ChannelVideosFetcher.new
      else
        Youtube::Real::ChannelVideosFetcher.new(
          youtube_service: @youtube
        )
      end
    end
  end
end
