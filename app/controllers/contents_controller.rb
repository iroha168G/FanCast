class ContentsController < ApplicationController
  def index
    youtube = Rails.application.config.youtube_service

    # テストで動画5件取得
    response = youtube.list_searches("snippet", q: "ポケモン作業用BGM", max_results: 5)
    @videos = response.items
  end
end
