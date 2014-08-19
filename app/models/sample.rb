# encoding: utf-8
class Sample < ActiveRecord::Base
  paginates_per 10
  
  belongs_to :alarm
  
  attr_accessor :has_triggered_alarm, :is_imported
  
  validates_numericality_of :value, :message => "El valor de la muestra debe ser numérico"
  
  after_create :increase_alarm_samples_counter, :check_alarm
  after_destroy :decrease_alarm_samples_counter
  
  def increase_alarm_samples_counter
    current_alarm = self.alarm
    current_alarm.update_attributes(:samples_count => current_alarm.samples_count + 1)     
  end
  
  def decrease_alarm_samples_counter
    current_alarm = self.alarm
    current_alarm.update_attributes(:samples_count => current_alarm.samples_count - 1)     
  end
  
  def check_alarm
    unless self.is_imported
      current_alarm = self.alarm
      if current_alarm.check
        # Registramos la notificación
        current_alarm.notifications << Notification.new({ :sample_id => self.id })
        # Y marcamos la muestra como desencadenante de una alarma
        self.has_triggered_alarm = true
      end
    end
  end
  
end
