class CssController < ApplicationController
  
  COLORS = {
    :white          => '#ffffff',
    :green          => '#93c83d',
    :blue           => '#0082d1',
    :dark_blue      => '#0062b1',
    :light_grey     => '#e0e6e8',
    :medium_grey    => '#c0cfd2',
    :dark_grey      => '#556170',
    :red            => '#f54029',
    :orange         => '#ffb517',
    :yellow         => '#f7d417'
  }
  
  layout nil
  
  skip_filter           :set_time_zone
  skip_filter           :load_grammatical_context
  skip_filter           :adjust_format_for_iphone
  append_before_filter  :set_format
  append_before_filter  :load_browser, :only => [:browser]
  
  def color
    @colors = CssController::COLORS
    render :action => 'color', :content_type => "text/css"
  end
  
  def browser
    render :action => @browser_name, :content_type => "text/css"
  end
  
  def not_found
    render(:nothing => true, :content_type => "text/css", :status => 404)
  end
  
  CssController::COLORS.keys.each do |k|
    define_method(k) { CssController::COLORS[k] }
    protected k
    helper_method k
  end
  
  protected
  def set_format
    request.format = :css
    true
  end
  
  def load_browser
    @browser_name ||= params[:browser]
    @browser_name ||= begin
      ua = request.env['HTTP_USER_AGENT'].downcase
      if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
        'ie' + ua[ua.index('msie')+5].chr
      elsif ua.index('gecko/') 
        'firefox'
      elsif ua.index('opera')
        'opera'
      elsif ua.index('konqueror') 
        'konqueror'
      elsif ua.index('applewebkit/')
        'safari'
      elsif ua.index('mozilla/')
        'firefox'
      end
    end
    @browser_name
  end
  
end