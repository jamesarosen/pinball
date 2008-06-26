# Thanks http://snippets.dzone.com/posts/show/2178

Hash.class_eval do
  
  def pass(*keys)
    tmp = self.dup.clear   # so we get whatever class self is
    keys.each { |k| tmp[k] = self[k] if self.has_key?(k) }
    tmp
  end
  
  def block(*keys)
    tmp = self.dup
    keys.each { |k| tmp.delete(k) }
    tmp
  end
  
end