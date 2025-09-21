class ContentsController < ApplicationController
  def index
    youtube = Rails.application.config.youtube_service

    # 検索ワード「test」で動画1件取得
    response = youtube.list_searches('snippet', q: 'STICKING OUT YOUR GYATT FOR NERIZZLER', max_results: 1)

    if response.items.any?
      snippet = response.items.first.snippet
      @title = snippet.title
      @thumbnail_url = snippet.thumbnails.default.url  # ← サムネイルURL
    else
      @title = "動画が見つかりませんでした"
      @thumbnail_url = nil
    end
  rescue Google::Apis::ClientError => e
    @title = "APIエラー: #{e.message}"
    @thumbnail_url = nil
  end
end
