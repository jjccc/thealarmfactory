class Highchart
  
  def initialize(alarm, notification)
    @samples = alarm.samples.where("id < ?", notification.sample_id).order(:created_at)
    @alarm = alarm
    @notification = notification
  end
  
  def data
    @samples
  end

  def start_at
    @samples.map(&:created_at).min
  end  
  
  def min
    sample_min = @samples.map(&:value).min
    sample_min = sample_min * 0.9 unless sample_min == 0         
    sample_min
  end
  
end