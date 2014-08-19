# encoding: utf-8
class Receiver < ActiveRecord::Base
  paginates_per 10
  
  belongs_to :alarm
  
  validates_presence_of :name, :message => "El destinatario no puede estar vacío."
  validates :name, :length => { :maximum => 255, 
                                :too_long => "El destinatario no puede tener más de %{count} caracteres."}
  
  def is_email?
    !self.name.nil? && self.name.partition("@").none?{ |x| x.blank? }
  end
  
  def is_twitter?
    !self.name.nil? && self.name.starts_with?("@") && !self.name.partition("@")[2].blank?
  end
  
end
