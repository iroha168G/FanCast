require "ostruct"

module Youtube
  module Mock
    class FavoriteChannels
      def all
        [
          OpenStruct.new(
            channel_id: "mock_channel_001",
            channel_identifier: "mock_channel_001",
            title: "Mock Channel 1",
            name: "Mock Channel 1",
            description: "これはモック用チャンネルです",
            icon: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            thumbnail_url: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            subscribers: 1,
            url: "https://www.youtube.com/channel/UCrXUsMBcfTVqwAS7DKg9C0Q",
            db_id: nil,
            favorite_id: nil
          ),
          OpenStruct.new(
            channel_id: "mock_channel_002",
            channel_identifier: "mock_channel_002",
            title: "Mock Channel 2",
            name: "Mock Channel 2",
            description: "これはモック用チャンネルです",
            icon: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            thumbnail_url: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            subscribers: 1000,
            url: "https://www.youtube.com/channel/UCrXUsMBcfTVqwAS7DKg9C0Q",
            db_id: 1,
            favorite_id: 1
          ),
          OpenStruct.new(
            channel_id: "mock_channel_003",
            channel_identifier: "mock_channel_003",
            title: "Mock Channel 3",
            name: "Mock Channel 3",
            description: "これはモック用チャンネルです",
            icon: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            thumbnail_url: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            subscribers: 1000000,
            url: "https://www.youtube.com/channel/UCrXUsMBcfTVqwAS7DKg9C0Q",
            db_id: nil,
            favorite_id: nil
          ),
          OpenStruct.new(
            channel_id: "mock_channel_004",
            channel_identifier: "mock_channel_004",
            title: "Mock Channel 4",
            name: "Mock Channel 4",
            description: "これはモック用チャンネルです",
            icon: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            thumbnail_url: "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
            subscribers: 100000000,
            url: "https://www.youtube.com/channel/UCrXUsMBcfTVqwAS7DKg9C0Q",
            db_id: 1,
            favorite_id: 1
          )
        ]
      end
    end
  end
end
