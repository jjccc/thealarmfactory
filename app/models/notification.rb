class Notification < ActiveRecord::Base
  paginates_per 10
  
  belongs_to :alarm
  
  after_create :complete_alarm, :notify
  
  def complete_alarm
    self.alarm.update_attributes(:has_notifications => true)     
  end
  
  def samples_until
    Sample.where(:alarm_id => self.alarm_id).where("id <= ?", self.sample_id).count
  end
  
  def notify
    self.alarm.receivers.each do |r|
      # Se envía la notificación a los receptores.
    end
  end
    
end
