# Thanks, LessEverything team!

String.class_eval do
  
  def quantitize(stuff)
    i = if stuff.kind_of?(Numeric)
      stuff
    elsif stuff.respond_to?(:length)
      stuff.length
    elsif stuff.respond_to?(:size)
      stuff.size
    else
      raise ArgumentError.new("Cannot determine quantity from #{stuff}")
    end
    
    case i
    when 0
      "no #{self.pluralize}"
    when 1
      "one #{self.singularize}"
    else
      "#{i} #{self.pluralize}"
    end
  end
  
  def strip_xml
    self.gsub(/<(.*?)>/, '')
  end

  def strip_tag_and_contents tag
    self.gsub(/<style.*>.*?<\/style>/mi, '')
  end

  def to_safe_uri
    self.strip.downcase.gsub('&', 'and').gsub(' ', '-').gsub(/[^\w-]/,'')
  end

  def from_safe_uri
    self.gsub('-', ' ')
  end

  def add_param(args = {})
    self.strip + (self.include?('?') ? '&' : '?') + args.map { |k,v| "#{k}=#{URI.escape(v.to_s)}" }.join('&')
  end

  def truncate(len = 30)
    return self if size <= len
    s = self[0, len - 3].strip
    s << '...'
  end
end