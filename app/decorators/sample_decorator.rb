class SampleDecorator < Draper::Decorator
  delegate_all

  def value
    h.number_with_delimiter(object.value)
  end
  
  def created_at
    I18n.l(object.created_at, :format => :complete)
  end
  
  def as_json(options = {})
    {
      id: object.id,
      created_at: self.created_at,
      value: object.value,
      formatted_value: self.value,
      url: options.blank? ? h.alarm_sample_url(object.alarm_id, object.id, {format: "json"}) : h.api_v1_alarm_sample_url(object.alarm_id, object.id),
      alarm_url: options.blank? ? h.alarm_url(object.alarm_id, {format: "json"}) : h.api_v1_alarm_url(object.alarm_id)
    }
  end
  
end
