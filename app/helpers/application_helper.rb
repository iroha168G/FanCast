module ApplicationHelper
  def flash_class(level)
    case level.to_sym
    when :notice then "bg-green-100 text-green-800"
    when :alert  then "bg-red-100 text-red-800"
    else "bg-gray-100 text-gray-800"
    end
  end

  def format_duration(iso8601)
    return "" if iso8601.blank?

    match = iso8601.match(/PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?/)
    return "" unless match

    hours   = match[1].to_i
    minutes = match[2].to_i
    seconds = match[3].to_i

    if hours > 0
      format("%d:%02d:%02d", hours, minutes, seconds)
    else
      format("%d:%02d", minutes, seconds)
    end
  end
end
