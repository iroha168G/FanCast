require 'rails_helper'

RSpec.describe Channel, type: :model do
  let(:channel) { create(:channel) }

  describe "enum" do
    it "youtubeがplatformとして使える" do
      channel = build(:channel, platform: :youtube)
      expect(channel.youtube?).to be true
    end
  end

  describe "association" do
    it "user_favorite_channels を持つ" do
      expect(Channel.reflect_on_association(:user_favorite_channels).macro).to eq :has_many
    end
  end

  describe "バリデーションチェック" do
    it "platformが無いと無効" do
      channel = build(:channel, platform: nil)
      channel.valid?
      expect(channel.errors[:platform]).to be_present
    end

    it "nameが無いと無効" do
      channel = build(:channel, name: nil)
      channel.valid?
      expect(channel.errors[:name]).to be_present
    end

    it "channel_identifierが無いと無効" do
      channel = build(:channel, channel_identifier: nil)
      channel.valid?
      expect(channel.errors[:channel_identifier]).to be_present
    end

    it "thumbnail_urlが無いと無効" do
      channel = build(:channel, thumbnail_url: nil)
      channel.valid?
      expect(channel.errors[:thumbnail_url]).to be_present
    end
  end
end
