module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module Regexp #:nodoc:
      
      # Adds Boolean logic to regular expressions.
      module Boolean
        
        def self.included(base)
          base.extend ClassMethods
        end
        
        # An alias for and(other)
        def &(other)
          self.and(other)
        end
        
        # @returns a RegAnd of +self+ and +other+.
        def and(other)
          RegAnd.new(self, other)
        end
        
        # An alias for or(other)
        def |(other)
          self.or(other)
        end
        
        # @returns a RegOr of +self+ and +other+
        def or(other)
          RegOr.new(self, other)
        end
        
        # @returns a RegNot of +self+.
        def inverse
          RegNot.new(self)
        end
        
        module ClassMethods
          # @returns a new RegNot based on +regex+.
          def not(regex)
            RegNot.new(regex)
          end
        end
        
      end
    end
  end
end

::Regexp.send :include, Tidbits::CoreExtensions::Regexp::Boolean

# The conjunction of two regular expressions.
# WARNING: the current implementation affects the
# regex-related global variables.
class RegAnd
  include Tidbits::CoreExtensions::Regexp::Boolean
  
  attr_reader :regex1, :regex2
  protected :regex1, :regex2

  # @raises ArgumentError if either argument doesn't respond to =~.
  def initialize(regex1, regex2)
    raise ArgumentError.new("Cannot create RegAnd from #{regex1}") unless regex1.respond_to?("=~".to_sym)
    raise ArgumentError.new("Cannot create RegAnd from #{regex2}") unless regex2.respond_to?("=~".to_sym)
    @regex1, @regex2 = regex1, regex2
  end

  # Alias for =~.
  def ===(str)
    self =~ str
  end

  # @returns the lesser of the two positions matched by the
  # underlying regular expressions if both match; nil otherwise.
  def =~(str)
    p1 = (regex1 =~ str)
    p2 = (regex2 =~ str)
    return nil unless p1 && p2
    [p1, p2].min
  end

  # @returns true if +self+ and +other+ are RegAnds with equivalent
  # underlying regular expressions.
  def ==(other)
    other.kind_of?(RegNot) && self.regex1 == other.regex1 && self.regex2 == other.regex2
  end
end

# The disjunction of two regular expressions.
# WARNING: the current implementation affects the
# regex-related global variables.
class RegOr
  include Tidbits::CoreExtensions::Regexp::Boolean
  
  attr_reader :regex1, :regex2
  protected :regex1, :regex2

  # @raises ArgumentError if either argument doesn't respond to =~.
  def initialize(regex1, regex2)
    raise ArgumentError.new("Cannot create RegNot from #{regex1}") unless regex1.respond_to?("=~".to_sym)
    raise ArgumentError.new("Cannot create RegNot from #{regex2}") unless regex2.respond_to?("=~".to_sym)
    @regex1, @regex2 = regex1, regex2
  end

  # Alias for =~.
  def ===(str)
    self =~ str
  end

  # @returns the position of the first match of one
  # of the underlying regular expressions if at least one matches;
  # nil otherwise.
  def =~(str)
    if p1 = (regex1 =~ str)
      return p1
    elsif p2 = (regex1 =~ str)
      return p2
    else
      return nil
    end
  end

  # @returns true if +self+ and +other+ are RegOrs with equivalent
  # underlying regular expressions.
  def ==(other)
    other.kind_of?(RegNot) && self.regex1 == other.regex1 && self.regex2 == other.regex2
  end
end
  
# The opposite of the regular expression it wraps.
# WARNING: the current implementation affects the
# regex-related global variables.
class RegNot
  include Tidbits::CoreExtensions::Regexp::Boolean

  attr_reader :regex
  protected :regex
  
  # @raises ArgumentError if +regex+ doesn't respond to =~.
  def initialize(regex)
    raise ArgumentError.new("Cannot create RegNot from #{regex}") unless regex.respond_to?("=~".to_sym)
    @regex = regex
  end
  
  # Alias for =~.
  def ===(str)
    self =~ str
  end
  
  # @returns 0 if the underlying Regexp does not match; nil if it does.
  def =~(str)
    (@regex =~ str).nil? ? 0 : nil
  end
  
  # @returns true if +self+ and +other+ are RegNots with equivalent
  # underlying regular expressions.
  def ==(other)
    other.kind_of?(RegNot) && self.regex == other.regex
  end
end