module ActionController::Resources
  
  class Resource
    def requirements(with_id = false)
      @requirements   ||= @options[:requirements] || {}
      @id_requirement ||= { "#{singular}_id".to_sym => @requirements.delete("#{singular}_id".to_sym) || @requirements.delete(:id) || /[^#{::ActionController::Routing::SEPARATORS.join}]+/ }

      with_id ? @requirements.merge(@id_requirement) : @requirements
    end
    
    def member_path
      @member_path ||= "#{path}/:#{singular}_id"
    end
  end
  
  private
  
  def map_unnamed_routes(map, path_without_format, options)
    map.connect("#{path_without_format}.:format", options)
  end
  
  def map_named_routes(map, name, path_without_format, options)
    map.named_route(name, "#{path_without_format}.:format", options)
  end
  
end

class ActionController::Routing::RouteSet::Mapper
  
  def get(options = {}, &block)
    options = { :conditions => { :method => :get } }.merge(options)
    options_or_with_options(options, &block)
  end
  
  def post(options = {}, &block)
    options = { :conditions => { :method => :post } }.merge(options)
    options_or_with_options(options, &block)
  end
  
  def put(options = {}, &block)
    options = { :conditions => { :method => :put } }.merge(options)
    options_or_with_options(options, &block)
  end
  
  def delete(options = {}, &block)
    options = { :conditions => { :method => :delete } }.merge(options)
    options_or_with_options(options, &block)
  end
  
  private
  
  # If block given, pass options to with_options, else return +options+ if no block given.
  def options_or_with_options(options, &block)
    if block_given?
      with_options(options, &block)
    else
      options
    end
  end
  
end

