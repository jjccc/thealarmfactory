class Parser  
  # Load the Treetop grammar and 
  # create a new instance of that parser as a class variable 
  # so we don't have to re-create it every time we need to 
  # parse a string
  require 'polyglot'
  require 'treetop'
  require 'syntax_nodes'

  base_path = File.expand_path(File.dirname(__FILE__)) 

  Treetop.load(File.join(base_path, 'condition.treetop'))
  
  @@parser = ConditionParser.new
  
  def self.parse(data)
    # Pass the data over to the parser instance
    tree = @@parser.parse(data)

    if(tree.nil?)
      raise Exception, "Parse error at offset: #{@@parser.index}"
    end
    
    self.clean_tree(tree)
    
    return tree.to_array
  end
  
  private
  
  def self.clean_tree(root_node)
    return if(root_node.elements.nil?)
    root_node.elements.delete_if{|node| node.class.name == "Treetop::Runtime::SyntaxNode" }
    root_node.elements.each {|node| self.clean_tree(node) }
  end

end