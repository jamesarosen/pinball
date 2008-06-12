class Module
  def define_once(sym, value)
    const_set(sym, value) unless const_defined?(sym)
  end
end

class Object
  def define_once(sym, value)
    self.class.define_once(sym, value)
  end
end