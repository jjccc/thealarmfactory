# encoding: utf-8
class Alarm < ActiveRecord::Base
  paginates_per 3
  
  has_many :notifications, :dependent => :destroy
  has_many :receivers, :dependent => :destroy
  has_many :samples, :dependent => :destroy
  has_many :operations, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :name, :message => "La alarma debe tener un nombre."
  validates :name, :length => { :maximum => 250, 
                                :too_long => "El nombre no puede tener más de %{count} caracteres."}
  validates :description, :length => { :maximum => 600, :too_long => "La descripción no puede tener más de %{count} caracteres." }
  
  attr_accessor :index_page
  attr_accessible :name, :description
  
  before_save :parse_condition
  
  def last_notification
    self.has_notifications? ? self.notifications.order("created_at desc, id desc").first : nil
  end
  
  def ordered_notifications
    self.has_notifications? ? self.notifications.order("created_at desc, id desc") : []
  end 
  
  def ordered_samples
    self.has_samples? ? self.samples.order("created_at desc, id desc") : []
  end 
    
  def has_receivers?
    self.receivers.count > 0
  end
  
  def has_samples?
    self.samples_count > 0
  end
    
  def has_more_receivers?
    self.receivers.count > 1
  end
  
  def more_receivers_count
    self.receivers.count - 1       
  end
  
  def check
    result = []
    self.operations.eager_load(:operator).order(:position).each do |o|
      result = o.calculate(result)      
    end
    !result.blank? && result.first
  end
  
  def parse_condition
    begin
      # En primer lugar comprobamos si ha cambiado la condición
      # Si no ha cambiado no hacemos nada
      current_alarm = Alarm.find(self.id)
      if current_alarm.condition != self.condition
        optree = Parser.parse(self.condition)
        # La condición ha cambiado y es válida.
        # Borramos el árbol de operaciones actual y grabamos el nuevo
        self.operations.clear
        optree.flatten!        
        # Tenemos que completar aquellas operaciones que corresponden a la muestra con el id de la misma.
        # y la posición de cada operación
        sample_op = Operator.find_by_name("sample")
        optree.each_with_index do |x, i|
          x.first_operand = self.id if x.operator_id == sample_op.id
          x.position = i + 1
        end
        self.operations << optree
      end
    rescue
    end
  end
  
end
