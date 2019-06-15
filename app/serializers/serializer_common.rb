module SerializerCommon
  module_function

  def format_date(date)
    return nil if date.nil?
    date.to_datetime.strftime("%d-%m-%Y %I:%M%p")
  end
end
