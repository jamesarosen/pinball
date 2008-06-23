# Mixin for Privacyness
module HasPrivacy
  
  def allows?(setting_name, audience)
    v = get_setting(setting_name)
    a = HasPrivacy::Authorization[v]
    raise "No Authorization found for setting value #{v}" unless a
    a.authorized?(audience, self)
  end
  
  # Available Authorizations:
  #
  # name::          <tt>authorized?(audience, subject)</tt>
  # 'everyone'::    +true+
  # 'logged_in'::   +true+ iff +audience+ is non-nil
  # 'followees'::   +true+ iff <tt>subject.following?(audience)<tt>
  #                 OR <tt>subject == audience</tt>
  # 'tier_1'::      +true+ iff
  #                 <tt>subject.following_in_tiers?(audience, 1)<tt>
  #                 OR <tt>subject == audience</tt>
  # 'tiers_1_2'::   +true+ iff
  #                 <tt>subject.following_in_tiers?(audience, 1, 2)<tt>
  #                 OR <tt>subject == audience</tt>
  # 'self'::        +true+ iff <tt>subject == audience</tt>
  class Authorization

    AUTHORIZATIONS = []
    EVERYONE = 'everyone'
    LOGGED_IN = 'logged_in'
    FOLLOWEES = 'followees'
    TIER_1_FOLLOWEES = 'tier_1'
    TIERS_1_2_FOLLOWEES = 'tiers_1_2'
    SELF = 'self'

    attr_reader :name

    def self.find(name)
      AUTHORIZATIONS.find { |a| a.name == name }
    end

    def self.[](name); find(name); end

    def authorized?(audience, subject)
      @proc.call(audience, subject)
    end

    def ==(other)
      other.kind_of?(Authorization) && other.name == name
    end

    def to_param
      to_s
    end

    def to_s
      name
    end

    private

    def initialize(name, &block)
      @name, @proc = name.to_s, Proc.new(&block)
    end

    AUTHORIZATIONS << new(EVERYONE) { |audience, subject| true }
    AUTHORIZATIONS << new(LOGGED_IN) { |audience, subject| !!audience }
    AUTHORIZATIONS << new(FOLLOWEES) do |audience, subject|
      audience && subject && (subject.following?(audience) || (audience == subject))
    end
    AUTHORIZATIONS << new(TIER_1_FOLLOWEES) do |audience, subject|
      audience && subject && (subject.following_in_tiers?(audience, 1) || (audience == subject))
    end
    AUTHORIZATIONS << new(TIERS_1_2_FOLLOWEES) do |audience, subject|
      audience && subject && (subject.following_in_tiers?(audience, 1, 2) || (audience == subject))
    end
    AUTHORIZATIONS << new(SELF) do |audience, subject|
      audience && subject && (audience == subject)
    end

  end
  
end