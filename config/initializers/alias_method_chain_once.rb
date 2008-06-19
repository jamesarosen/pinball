class Module
  def alias_method_chain_once(target, feature)
    aliased_target, punctuation = target.to_s.sub(/([?!=])$/, ''), $1
    without_method = "#{aliased_target}_without_#{feature}#{punctuation}"
    unless method_defined?(without_method)
      alias_method_chain(target, feature)
    end
  end
end
    