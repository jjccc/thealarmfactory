class Import
  attr_accessor :file, :type, :value, :from, :alarm_id, :from_index
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  def persisted?
    false
  end
  
  def initialize(options)
    self.type = options[:type] || "xls"    
    self.value = options[:value] || nil
    self.from = options[:from] || "file"
    self.file = options[:file] || nil
    self.alarm_id = options[:alarm_id] || nil
    self.from_index = options[:from_index].present? && options[:from_index] == "true"
  end
  
  def is_file?
    self.from == "file"
  end
  
  def to_sample
    result = false
    begin
      if (!self.is_file? && !self.value.blank?) || (self.is_file? && !self.file.nil?)
        alarm = Alarm.find_by_id(self.alarm_id.to_i)
        unless alarm.nil?
          if self.is_file?
            # Importando datos desde un archivo.
            File.open(self.file.tempfile, "r") do |f|
              while line = f.gets
                alarm.samples << Sample.new({:value => line.gsub(".", "").gsub(",", ".").to_f,
                                             :is_imported => true})
              end
            end            
          else
            # Importando datos desde el control del formulario.
            self.value.split("\n").each do |s|
              alarm.samples << Sample.new({:value => s.gsub(".", "").gsub(",", ".").to_f,
                                           :is_imported => true})
            end
          end
          result = true          
        end
      end            
    rescue
    end
    return result
  end
  
end
