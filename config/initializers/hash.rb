# Thanks http://snippets.dzone.com/posts/show/2178

Hash.class_eval do
  
  def pass(*keys)
    tmp = self.dup
    tmp.delete_if {|k,v| ! tmp.has_key?(k) }
    tmp
  end
  
  def block(*keys)
    tmp = self.dup
    tmp.delete_if {|k,v| tmp.has_key?(k) }
    tmp
  end
  
end