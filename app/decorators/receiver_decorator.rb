# encoding: utf-8
class ReceiverDecorator < Draper::Decorator
  delegate_all

  def network
    if object.is_twitter?
      "Twitter"
    else
      if object.is_email?
        "Correo electrónico"
      else
        "Destinatario incorrecto"
      end
    end
  end
  
  def as_json(options = {})
    {
      name: object.name,
      network: self.network      
    }
  end

end
