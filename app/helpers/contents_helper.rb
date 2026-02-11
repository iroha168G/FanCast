module ContentsHelper
  def current_status
    params[:status].presence || "live"
  end
  def tab_class(status)
    base = "px-4 py-2 rounded-full border"

    if current_status == status
      "#{base} bg-blue-500 text-white border-blue-400"
    else
      "#{base} bg-gray-800 text-white border-gray-400"
    end
  end
end
