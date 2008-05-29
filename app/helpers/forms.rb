require 'action_view/helpers/form_helper'
require 'action_view/helpers/form_tag_helper'
require 'action_view/helpers/form_options_helper'

module Forms
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  
  # Within a form_for(@model):
  
  def label_with_default(object_name, method, text = nil, options = nil)
    text ||= "#{method.to_s.titleize}: "
    options ||= {}
    label_without_default(object_name, method, text, options)
  end
  
  def text_field_with_before_and_after(object_name, method, options = {})
    before(object_name, method, options) +
      text_field_without_before_and_after(object_name, method, options) + 
      after(object_name, method, options)
  end
  
  def password_field_with_before_and_after(object_name, method, options = {})
    before(object_name, method, options) +
      password_field_without_before_and_after(object_name, method, options) +
      after(object_name, method, options)
  end
   
  def hidden_field_with_before_and_after(object_name, method, options = {})
    before(object_name, method, options) +
      hidden_field_without_before_and_after(object_name, method, options) +
      after(object_name, method, options)
  end
   
  def file_field_with_before_and_after(object_name, method, options = {})
    before(object_name, method, options) +
      file_field_without_before_and_after(object_name, method, options) +
      after(object_name, method, options)
  end
  
  def text_area_with_before_and_after(object_name, method, options = {})
    before(object_name, method, options) +
      text_area_without_before_and_after(object_name, method, options) +
      after(object_name, method, options)
  end

  def check_box_with_before_and_after(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
    before(object_name, method, options) +
      check_box_without_before_and_after(object_name, method, options, checked_value, unchecked_value) +
      after(object_name, method, options)
  end

  def radio_button_with_before_and_after(object_name, method, tag_value, options = {})
    before(object_name, method, options) +
      radio_button_without_before_and_after(object_name, method, tag_value, options) +
      after(object_name, method, options)
  end
  
  def select_with_before_and_after(object_name, method, choices, options = {}, html_options = {})
    before(object_name, method, options) +
      select_without_before_and_after(method, choices, options, html_options) +
      after(object_name, method, options)
  end
  
  # Within a form (no model)
  
  def label_tag_with_default(name, text = nil, options = nil)
    text ||= "#{name.to_s.titleize}: "
    options ||= {}
    label_tag_without_default(name, text, options)
  end
  
  def select_tag_with_before_and_after(name, option_tags = nil, options = {})
    before(nil, name, options) +
      select_tag_without_before_and_after(name, value, options) + 
      after(nil, name, options)
  end
  
  def text_field_tag_with_before_and_after(name, value = nil, options = {})
    before(nil, name, options) +
      text_field_tag_without_before_and_after(name, value, options) + 
      after(nil, name, options)
  end
  
  def hidden_field_tag_with_before_and_after(name, value = nil, options = {})
    before(nil, name, options) +
      hidden_field_tag_without_before_and_after(name, value, options) + 
      after(nil, name, options)
  end
  
  def file_field_tag_with_before_and_after(name, options = {})
    before(nil, name, options) +
      file_field_tag_without_before_and_after(name, options) + 
      after(nil, name, options)
  end
  
  def text_area_tag_with_before_and_after(name, content = nil, options = {})
    before(nil, name, options) +
      text_area_tag_without_before_and_after(name, content, options) + 
      after(nil, name, options)
  end
  
  def check_box_tag_with_before_and_after(name, value = 1, checked = false, options = {})
    before(nil, name, options) +
      check_box_tag_without_before_and_after(name, value, checked, options) + 
      after(nil, name, options)
  end
  
  def radio_button_tag_with_before_and_after(name, value, checked = false, options = {})
    before(nil, name, options) +
      radio_button_tag_without_before_and_after(name, value, options) + 
      after(nil, name, options)
  end
  
  def submit_tag_with_before_and_after(value, options = {})
    # force label and error messages to none
    options = options.merge(:label => false, :error_messages => false)
    before(nil, nil, options) +
      submit_tag_without_before_and_after(value, options) +
      after(nil, nil, options)
  end
  
  def image_submit_tag_with_before_and_after(source, options = {})
    # force label and error messages to none
    options = options.merge(:label => false, :error_messages => false)
    before(nil, nil, options) +
      image_submit_tag_without_before_and_after(source, options) +
      after(nil, nil, options)
  end
  
  
  unless method_defined?(:text_field_without_before_and_after)
    alias_method_chain :label, :default
    alias_method_chain :text_field, :before_and_after
    alias_method_chain :password_field, :before_and_after
    alias_method_chain :hidden_field, :before_and_after
    alias_method_chain :file_field, :before_and_after
    alias_method_chain :text_area, :before_and_after
    alias_method_chain :check_box, :before_and_after
    alias_method_chain :radio_button, :before_and_after
    alias_method_chain :select, :before_and_after
    
    alias_method_chain :label_tag, :default
    alias_method_chain :select_tag, :before_and_after
    alias_method_chain :text_field_tag, :before_and_after
    alias_method_chain :hidden_field_tag, :before_and_after
    alias_method_chain :file_field_tag, :before_and_after
    alias_method_chain :text_area_tag, :before_and_after
    alias_method_chain :check_box_tag, :before_and_after
    alias_method_chain :radio_button_tag, :before_and_after
    alias_method_chain :submit_tag, :before_and_after
    alias_method_chain :image_submit_tag, :before_and_after
  end
  
  private
  
  def before(object_name, method, options)
    result = '<div>'
    unless  options[:label] == false
      text, options = options.delete(:label), options.delete(:label_options)
      if object_name
        result << label(object_name, method, text, options)
      else
        result << label_tag(method, text, options)
      end
    end
    result
  end
  
  def after(object_name, method, options)
    result = ''
    if object_name and options.delete(:error_messages) != false
      result << error_message_on(object_name, method)
    end
    result << '</div>'
    result
  end

end