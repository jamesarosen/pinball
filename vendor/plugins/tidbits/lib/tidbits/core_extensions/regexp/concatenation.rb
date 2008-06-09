require 'tidbits/core_extensions/regexp/boolean'

module Tidbits #:nodoc:
  module CoreExtensions #:nodoc:
    module Regexp #:nodoc:
      
      # Adds a concatenate (or +) method to regular expressions
      module Concatenation
        
        ENDS_WITH_DOLLAR_SIGN = /\$$/
        ENDS_WITH_UNESCAPED_DOLLAR_SIGN = ENDS_WITH_DOLLAR_SIGN & ::Regexp.not(/[^\\](\\\\)*\\\$$/)
        
        # Alias for concatenate(+other+).
        def +(other)
          concatenate(other)
        end
        
        # Build a new Regular Expression comprised of
        # +self+ concatenated with +other+.  Drops the
        # end-of-line matcher ('...$') from +self+ and the
        # start-of-line matcher ('^...') from +other+ if
        # they exist as otherwise the returned Regex
        # would not match anything.  Copies options (ignorecase,
        # multiline, extended) from +self+.
        def concatenate(other)
          s1 = self.source
          
          # escaped $ but not an escaped \ before the dollar
          s1 = s1[0..-2] if s1 =~ ENDS_WITH_UNESCAPED_DOLLAR_SIGN
          s2 = other.source
          s2 = s2[1..-1] if (s2[0] == '^'[0])
          
          ::Regexp.new("#{s1}#{s2}", self.options)
        end
        
      end
    end
  end
end

::Regexp.send :include, Tidbits::CoreExtensions::Regexp::Concatenation