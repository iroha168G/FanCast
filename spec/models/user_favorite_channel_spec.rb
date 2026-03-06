require 'rails_helper'

RSpec.describe UserFavoriteChannel, type: :model do
  let(:user) { build(:user) }
  let(:channel) { create(:channel) }

  it "userがないと無効" do
    record = build(:user_favorite_channel, user: nil)
    record.valid?
    expect(record.errors[:user]).to be_present
  end

  it "channelがないと無効" do
    record = build(:user_favorite_channel, channel: nil)
    record.valid?
    expect(record.errors[:channel]).to be_present
  end

  it "userとchannelがあれば有効" do
    record = build(:user_favorite_channel)
    expect(record).to be_valid
  end
end
