module Youtube
  class Client
    def initialize(user:, youtube_service:)
      @provider =
        Youtube::ChannelVideosProvider.new(
          user: user,
          youtube_service: youtube_service
        )
    end

    def fetch(channel_id, status)
      @provider.fetch(channel_id, status)
    end
  end
end
