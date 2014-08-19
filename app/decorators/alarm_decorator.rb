class AlarmDecorator < Draper::Decorator
  delegate_all

  def samples_count
    h.number_with_delimiter(object.samples_count)
  end
  
  def tab_notifications_title
    "Notificaciones de alarma (#{self.notifications_count})"
  end
  
  def tab_samples_title
    "Muestras (#{self.samples_count})"
  end
  
  def tab_receivers_title
    "Destinatarios (#{self.receivers_count})"
  end
  
  def created_at
    I18n.l(object.created_at)
  end
  
  def show_url
    h.alarm_url(object)
  end

  def show_path
    h.alarm_path(object)
  end
  
  def add_sample_url
    h.alarm_samples_path(object)
  end
  
  def add_receiver_url
    h.alarm_receivers_path(object)
  end
  
  def destroy_url
    object.index_page.nil? ? h.alarm_path(object) : h.alarm_path(object, { :page => object.index_page })
  end
  
  def export_url
    h.export_alarm_path(object)
  end
  
  def last_notification_created_at_date
    object.last_notification.nil? ? "" : I18n.l(object.last_notification.created_at)
  end
  
  def last_notification_created_at_time
    object.last_notification.nil? ? "" : I18n.l(object.last_notification.created_at, :format => :time)
  end
  
  def notifications_count
    h.number_with_delimiter(object.notifications.count)
  end
  
  def decorated_notifications
    NotificationDecorator.decorate_collection(object.ordered_notifications)
  end
  
  def receivers_count
    h.number_with_delimiter(object.receivers.count)
  end
  
  def decorated_receivers
    ReceiverDecorator.decorate_collection(object.receivers)
  end
  
  def decorated_receivers_page(n)
    ReceiverDecorator.decorate_collection(object.receivers.order(:created_at).page(n))
  end
  
  def decorated_samples
    SampleDecorator.decorate_collection(object.ordered_samples)
  end
  
  def samples_count_text
    (object.samples_count != 1) ? "muestras" : "muestra" 
  end

  def first_receiver
    r = decorated_receivers.first
    r.nil? ? "" : r.name
  end
  
  def has_receivers
    object.has_receivers?
  end
  
  def has_more_receivers
    object.has_more_receivers?
  end
  
  def as_json(options={})
    a = {
      id: object.id,      
      name: object.name,
      samples_count: self.samples_count.to_i,
      description: object.description
    }
    
    if options.blank?
      # La petición viene de la web
      a.merge!({
        show_url: self.show_path,
        samples_count_text: self.samples_count_text,
        has_notifications: object.has_notifications,
        last_notification_created_at_date: self.last_notification_created_at_date,
        last_notification_created_at_time: self.last_notification_created_at_time,
        created_at: self.created_at,
        has_receivers: self.has_receivers,
        first_receiver: self.first_receiver,
        has_more_receivers: self.has_more_receivers,
        more_receivers_count: self.more_receivers_count,        
        add_sample_url: self.add_sample_url,
        add_receiver_url: self.add_receiver_url,
        destroy_url: self.destroy_url,
        export_url: self.export_url
      })      
    else
      # La petición viene de la API
      a.merge!({        
        last_notification_created_at: "#{self.last_notification_created_at_date} #{self.last_notification_created_at_time}" ,
        condition: object.condition,
        receivers: ReceiverDecorator.decorate_collection(object.receivers).as_json(options),
        samples_url: h.api_v1_alarm_samples_url(object.id),
        url: h.api_v1_alarm_url(object.id)
      })
    end

    a
  end
  
end
