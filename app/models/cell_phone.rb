require 'sms_fu'

module CellPhone
  
  def self.included(base)
    base.validates_each(:cell_carrier, :allow_blank => true) do |base, attribute, value|
      base.errors.add(attribute, 'is not a valid cellular provider') unless value.kind_of?(CellPhone::Carrier)
    end
  end
  
  def cell_number=(number)
    @cell_number = CellPhone::Number.parse(number)
    write_attribute(:cell_number, @cell_number.to_s)
  end
  
  def cell_number(reload = false)
    @cell_number = nil if reload
    @cell_number ||= CellPhone::Number.parse(read_attribute(:cell_number))
  end
  
  def cell_carrier=(carrier)
    @cell_carrier = CellPhone::Carrier.parse(carrier)
    write_attribute(:cell_carrier, @cell_carrier.to_param)
  end
  
  def cell_carrier(reload = false)
    @cell_carrier = nil if reload
    @cell_carrier ||= CellPhone::Carrier.parse(read_attribute(:cell_carrier))
  end
  
  def can_sms_fu?
    cell_number.kind_of?(CellPhone::Number) && cell_number.can_sms_fu? &&
      cell_carrier.kind_of?(CellPhone::Carrier) && cell_carrier.can_sms_fu?
  end
  
  # Can't be instantiated normally; use CellPhone::Number.parse(value)
  class Number
    
    def self.parse(value)
      case value
      when nil
        nil
      when CellPhone::Number
        value
      else
        value.to_s.blank? ? nil : CellPhone::Number.new(value.to_s)
      end
    end
    
    def initialize(value)
      @value = value
    end
    
    def to_s
      @value.dup
    end
    
    def to_param
      @value.to_safe_uri
    end
    
    def sms_fu_number
      i = @value.gsub(/[^[:digit:]]/, '')
      return nil if i.blank?
      (i.length == 11 && i[0,1] == "1") ? i[1..i.length] : i
    end
    
    def ==(other)
      other.kind_of?(CellPhone::Number) && sms_fu_number == other.sms_fu_number
    end
    
    def can_sms_fu?
      !sms_fu_number.nil?
    end

  end
  
  
  # Can't be instantiated normally; use CellPhone::Carrier.parse(value)
  class Carrier
    
    CARRIERS = [] unless Carrier.const_defined?(:CARRIERS)
  
    def self.parse(carrier)
      CARRIERS.find { |c| c === carrier } || carrier
    end
  
    def initialize(param_name)
      @param_name = param_name.to_safe_uri
      @pretty_name = self.class.pretty_name(@param_name)
    end
    
    def ===(match)
      self == match || to_param == match
    end

    def to_param
      @param_name.dup
    end

    def to_s
      display_name
    end
    
    def display_name
      @pretty_name.dup
    end

    def sms_fu_name
      to_param
    end
    
    def can_sms_fu?
      true
    end
    
    def self.pretty_name(name)
      value = name.titleize
      value.gsub!(/at(&|and)t/i, 'AT&T')
      value.gsub!(/\buk\b/i, 'UK')
      value.gsub!(/\bjp\b/i, 'JP')
      value.gsub!('T Mobile', 'T-Mobile')
      value.gsub!('E Plus', 'E-Plus')
      value
    end
    
    class <<self
      private :new
    end
    
    SMSFu.carriers.each do |name, email|
      next if name.blank?
      begin
        CARRIERS << new(name)
      rescue Exception => e
        p e
      end
    end
    
    CARRIERS.sort! { |x, y| x.to_s <=> y.to_s }
    
    CARRIERS.freeze

  end
end
CellPhone::Number.freeze
CellPhone::Carrier.freeze