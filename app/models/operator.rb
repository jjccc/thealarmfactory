class Operator < ActiveRecord::Base
  has_many :operations, :dependent => :destroy
  belongs_to :operator_type
  
  def calculate(*args)
    # DEBUG INFO
    s = "********************************\n"
    s += "Calculando #{self.name}"
    args.each do |arg|
      s += ", #{arg.as_json}"
    end
    s += "\n"
    s += "********************************\n"
    print s
    # FIN DEBUG
    
    result = Operator.send(self.name.parameterize.underscore.to_sym, *args)
    
    # DEBUG INFO
    print "********************************\n"
    print "Resultado = #{result}\n"
    print "********************************\n"
    # FIN DEBUG
    
    result        
  end
  
  # a = 5
  def self.constant(value)
    Float(value) rescue nil
  end 
  
  # a < b
  def self.less_than(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) < Float(second_operand)
    else
      nil
    end     
  end
  
  # a > b
  def self.greater_than(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) > Float(second_operand)
    else
      nil
    end     
  end
  
  # a == b
  def self.equal_than(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) == Float(second_operand)
    else
      nil
    end     
  end
  
  # a <= b
  def self.less_or_equal_than(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) <= Float(second_operand)
    else
      nil
    end     
  end
  
  # a >= b
  def self.greater_or_equal_than(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) >= Float(second_operand)
    else
      nil
    end     
  end
  
  # a != b
  def self.distinct(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) != Float(second_operand)
    else
      nil
    end     
  end
  
  # tamaño de una muestra
  def self.size(collection)
    collection.is_a?(Enumerable) ? collection.size : nil
  end
  
  # a - b
  def self.minus(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) - Float(second_operand)
    else
      nil
    end     
  end
  
  # a + b
  def self.plus(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) + Float(second_operand)
    else
      nil
    end     
  end
  
  # a * b
  def self.per(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) * Float(second_operand)
    else
      nil
    end     
  end
  
  # a / b
  def self.between(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil? || Float(second_operand) == 0
      Float(first_operand) / Float(second_operand)
    else
      nil
    end     
  end
  
  # a mod b
  def self.module(first_operand, second_operand)
    unless (Float(first_operand) rescue nil).nil? || (Float(second_operand) rescue nil).nil?
      Float(first_operand) % Float(second_operand)
    else
      nil
    end     
  end
  
  # sqrt(a)
  def self.sqrt(operand)
    unless (Float(operand) rescue nil).nil? || operand < 0
      Math.sqrt(Float(operand))
    else
      nil
    end
  end
  
  # pow(a, b)
  def self.pow(base, exponent)
    unless (Float(base) rescue nil).nil? || (Float(exponent) rescue nil).nil?
      base ** exponent
    else
      nil
    end
  end
  
  # Sumatorio de una muestra
  def self.summation(collection)
    if collection.is_a?(Enumerable)
      summa = 0
      collection.each do |e|
        if (Float(e) rescue nil).nil?
          return nil
        else
          summa += Float(e)
        end 
      end
      summa
    else 
      nil
    end
  end
  
  # Producto de una muestra
  def self.multiplication(collection)
    if collection.is_a?(Enumerable)
      multiplication = 1
      collection.each do |e|
        if (Float(e) rescue nil).nil?
          return nil
        else
          multiplication *= Float(e)
        end 
      end
      multiplication
    else 
      nil
    end
  end
  
  # Media de una muestra
  def self.average(collection)
    if collection.is_a?(Enumerable)
      summa = self.summation(collection)
      (summa.nil? || collection.blank?) ? nil : (summa / collection.size)      
    else 
      nil
    end
  end
  
  # Máximo de una muestra
  def self.max(collection)
    if collection.is_a?(Enumerable)
      collection.blank? ? nil : collection.max
    else
      nil
    end
  end
  
  # Mínimo de una muestra
  def self.min(collection)
    if collection.is_a?(Enumerable)
      collection.blank? ? nil : collection.min
    else
      nil
    end
  end
  
  # Elemento i-ésimo de una muestra
  def self.ith(collection, i)
    if collection.is_a?(Enumerable) && (i <= collection.count) && (i > 0) && !(Integer(i) rescue nil).nil?
      collection[i - 1]
    else
      nil
    end
  end
  
  # a and b
  def self.and(first_operand, second_operand)    
    (first_operand && second_operand) rescue nil      
  end
  
  # a or b
  def self.or(first_operand, second_operand)    
    (first_operand || second_operand) rescue nil      
  end
  
  # not a
  def self.not(operand)
    !operand rescue nil
  end
  
  # Primer elemento de una muestra
  def self.first(collection)
    if collection.is_a?(Enumerable)
      collection.first
    else
      nil
    end
  end
  
  # Último elemento de una muestra
  def self.last(collection)
    if collection.is_a?(Enumerable)
      collection.last
    else
      nil
    end
  end
  
  # Varianza de una muestra
  def self.variance(collection)
    if collection.is_a?(Enumerable)
      avg = self.average(collection)
      avg.nil? ? nil : self.average(collection.map{ |x| (x - avg) ** 2 }) 
    else
      nil
    end
  end
  
  # Desviación típica de una muestra
  def self.stdev(collection)
    if collection.is_a?(Enumerable)
      v = self.variance(collection)
      v.nil? ? nil : Math.sqrt(v)
    else
      nil
    end
  end
  
  # Moda de una muestra
  def self.mode(collection)
    if collection.is_a?(Enumerable)
      a = {}
      collection.each do |e|
        a[e] = 0 unless a.has_key?(e)
        a[e] += 1
      end
      max = nil
      a.keys.each do |k|
        max = k if max.nil? || a[k] > a[max]
      end
      max
    else
      nil
    end
  end
  
  # Mediana de una muestra
  def self.median(collection)
    if collection.is_a?(Enumerable) && !collection.blank?
      collection.sort!      
      if collection.count % 2 == 0
        (collection[(collection.count / 2) - 1] + collection[(collection.count / 2)]) / 2 
      else
        collection[((collection.count + 1) / 2) - 1]
      end 
    else
      nil      
    end
  end
  
  # Muestra
  def self.sample(alarm_id, count)
    alarm = Alarm.find_by_id(alarm_id)
    return nil if alarm.nil?
    count.nil? ? alarm.samples.order("created_at, id").map(&:value) : alarm.samples.order("created_at, id").map(&:value).limit(count) 
  end
  
end
