class NotificationDecorator < Draper::Decorator
  delegate_all

  def samples_count
    h.number_with_delimiter(object.samples_until)
  end
  
  def created_at
    I18n.l(object.created_at, :format => :complete)
  end
  
end
