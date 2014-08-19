class Operation < ActiveRecord::Base
  belongs_to :alarm
  belongs_to :operator
  
  # La función recibe como parámetro una pila que contiene los resultados de operaciones anteriores y
  # donde se va a devolver el resultado de la operación actual.
  def calculate(stack)
    op1 = nil
    op2 = nil
    
    unless stack.nil?
      # Determinamos el segundo parámetro de la operación. 
      # Lo calculamos antes que el primero porque en la pila vendrán al revés los parámetros. 
      unless self.second_operand.blank?
        # Si el segundo operando es @ se extrae de la pila
        op2 = self.second_operand == "@" ? stack.pop : (Float(self.second_operand) rescue nil)        
        return nil if op2.nil? 
      end
      
      # Determinamos el primer parámetro de la operación
      unless self.first_operand.blank?
        # Si el primer operando es @ se extrae de la pila
        op1 = self.first_operand == "@" ? stack.pop : (Float(self.first_operand) rescue nil)        
        return nil if op1.nil? 
      end      
      
      op = self.operator
      if op.operands == 1
        result = op.calculate(op1)
      else
        result = op.calculate(op1, op2)
      end
      
      return nil if result.nil?
      
      stack.push(result)
    end
    
    stack    
  end
  
end
