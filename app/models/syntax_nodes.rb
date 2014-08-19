module Condition
 
  class Literal < Treetop::Runtime::SyntaxNode
    def to_array
      op = Operation.new
      op.operator_id = Operator.find_by_name("constant").id
      op.first_operand = self.text_value
      return op 
    end
  end
  
  class ConditionOperator < Treetop::Runtime::SyntaxNode
    def to_array
      return self.text_value
    end
  end
  
  class SampleOperator < Treetop::Runtime::SyntaxNode
    def to_array
      op1 = Operation.new
      op1.operator_id = Operator.find_by_name("sample").id      
      op2 = Operation.new
      op2.operator_id = Operator.find_by_symbol(self.text_value).id     
      op2.first_operand = "@"
      return [op1, op2]
    end
  end
  
  class IthOperator < Treetop::Runtime::SyntaxNode
    def to_array
      op1 = Operation.new
      op1.operator_id = Operator.find_by_name("sample").id
      op2.second_operand = self.elements[0].text_value      
      op2 = Operation.new      
      op2.operator_id = Operator.find_by_symbol(self.text_value).id     
      op2.first_operand = "@"
      return [op1, op2]
    end
  end
  
  class AdditiveExpression < Treetop::Runtime::SyntaxNode
    def to_array
      op = Operation.new
      op.operator_id = Operator.find_by_symbol(self.elements[1].text_value).id
      op.first_operand = "@"
      op.second_operand = "@"
      return [self.elements[0].to_array, self.elements[2].to_array, op]      
    end
  end
  
  class MultitiveExpression < Treetop::Runtime::SyntaxNode
    def to_array
      op = Operation.new
      op.operator_id = Operator.find_by_symbol(self.elements[1].text_value).id
      op.first_operand = "@"
      op.second_operand = "@"
      return [self.elements[0].to_array, self.elements[2].to_array, op]
    end
  end
  
  class PrimaryExpression < Treetop::Runtime::SyntaxNode
    def to_array
      return self.elements.map {|x| x.to_array}
    end
  end
  
  class ComparisonExpression < Treetop::Runtime::SyntaxNode
    def to_array
      op = Operation.new
      op.operator_id = Operator.find_by_symbol(self.elements[1].text_value).id
      op.first_operand = "@"
      op.second_operand = "@"
      
      return [self.elements[0].to_array, self.elements[2].to_array, op]
    end
  end

end