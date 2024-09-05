module ApplicationHelper
  def format_datetime(datetime_string)
    Time.parse(datetime_string).in_time_zone('Tokyo').strftime('%Y/%m/%d %H:%M:%S')
  end
end
