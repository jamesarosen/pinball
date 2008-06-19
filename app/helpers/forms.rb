require 'action_view/helpers/form_helper'
require 'action_view/helpers/form_tag_helper'
require 'action_view/helpers/form_options_helper'

module Forms
  include ActionView::Helpers::FormHelper
  include ActionView::Helpers::FormTagHelper
  include ActionView::Helpers::FormOptionsHelper
  
  def option_text_and_value(option)
    return [option, option] if option.kind_of?(String)
    return [option.first, option.last] if option.respond_to?(:first) and option.respond_to?(:last)
    return [option.to_s, option.to_param] if option.respond_to?(:to_param)
    return [option, option]
  end
  
  # Within a form_for(@model):
  
  def label_with_default(object_name, method, text = nil, options = nil)
    text ||= "#{method.to_s.titleize}: "
    options ||= {}
    label_without_default(object_name, method, text, options)
  end
  
  def text_field_with_before_and_after(object_name, method, options = {})
    with_before_and_after(object_name, method, options) do
      text_field_without_before_and_after(object_name, method, options)
    end
  end
  
  def password_field_with_before_and_after(object_name, method, options = {})
    with_before_and_after(object_name, method, options) do
      password_field_without_before_and_after(object_name, method, options)
    end
  end
   
  def hidden_field_with_before_and_after(object_name, method, options = {})
    with_before_and_after(object_name, method, options) do
      hidden_field_without_before_and_after(object_name, method, options)
    end
  end
   
  def file_field_with_before_and_after(object_name, method, options = {})
    with_before_and_after(object_name, method, options) do
      file_field_without_before_and_after(object_name, method, options)
    end
  end
  
  def text_area_with_before_and_after(object_name, method, options = {})
    with_before_and_after(object_name, method, options) do
      text_area_without_before_and_after(object_name, method, options)
    end
  end

  def check_box_with_before_and_after(object_name, method, options = {}, checked_value = "1", unchecked_value = "0")
    with_before_and_after(object_name, method, options) do
      check_box_without_before_and_after(object_name, method, options, checked_value, unchecked_value)
    end
  end

  def radio_button_with_before_and_after(object_name, method, tag_value, options = {})
    with_before_and_after(object_name, method, options) do
      radio_button_without_before_and_after(object_name, method, tag_value, options)
    end
  end
  
  def select_with_before_and_after(object_name, method, choices, options = {}, html_options = {})
    with_before_and_after(object_name, method, options) do
      select_without_before_and_after(object_name, method, choices, options, html_options)
    end
  end
  
  # Within a form (no model)
  
  def label_tag_with_default(name, text = nil, options = nil)
    text ||= "#{name.to_s.titleize}: "
    options ||= {}
    label_tag_without_default(name, text, options)
  end
  
  def select_tag_with_before_and_after(name, option_tags = nil, options = {})
    with_before_and_after(nil, name, options) do
      select_tag_without_before_and_after(name, value, options)
    end
  end
  
  def text_field_tag_with_before_and_after(name, value = nil, options = {})
    with_before_and_after(nil, name, options) do
      text_field_tag_without_before_and_after(name, value, options)
    end
  end
  
  def hidden_field_tag_with_before_and_after(name, value = nil, options = {})
    with_before_and_after(nil, name, options) do
      hidden_field_tag_without_before_and_after(name, value, options)
    end
  end
  
  def file_field_tag_with_before_and_after(name, options = {})
    with_before_and_after(nil, name, options) do
      file_field_tag_without_before_and_after(name, options)
    end
  end
  
  def text_area_tag_with_before_and_after(name, content = nil, options = {})
    with_before_and_after(nil, name, options) do
      text_area_tag_without_before_and_after(name, content, options)
    end
  end
  
  def check_box_tag_with_before_and_after(name, value = 1, checked = false, options = {})
    with_before_and_after(nil, name, options) do
      check_box_tag_without_before_and_after(name, value, checked, options)
    end
  end
  
  def radio_button_tag_with_before_and_after(name, value, checked = false, options = {})
    with_before_and_after(nil, name, options) do
      radio_button_tag_without_before_and_after(name, value, options)
    end
  end
  
  def submit_tag_with_before_and_after(value, options = {})
    # force label and error messages to none
    with_before_and_after(nil, nil, options.merge(:label => false, :error_messages => false)) do
      submit_tag_without_before_and_after(value, options)
    end
  end
  
  def image_submit_tag_with_before_and_after(source, options = {})
    # force label and error messages to none
    with_before_and_after(nil, nil, options.merge(:label => false, :error_messages => false)) do
      image_submit_tag_without_before_and_after(source, options)
    end
  end
  
  
  alias_method_chain_once :label, :default
  alias_method_chain_once :text_field, :before_and_after
  alias_method_chain_once :password_field, :before_and_after
  alias_method_chain_once :hidden_field, :before_and_after
  alias_method_chain_once :file_field, :before_and_after
  alias_method_chain_once :text_area, :before_and_after
  alias_method_chain_once :check_box, :before_and_after
  alias_method_chain_once :radio_button, :before_and_after
  alias_method_chain_once :select, :before_and_after
  
  alias_method_chain_once :label_tag, :default
  alias_method_chain_once :select_tag, :before_and_after
  alias_method_chain_once :text_field_tag, :before_and_after
  alias_method_chain_once :hidden_field_tag, :before_and_after
  alias_method_chain_once :file_field_tag, :before_and_after
  alias_method_chain_once :text_area_tag, :before_and_after
  alias_method_chain_once :check_box_tag, :before_and_after
  alias_method_chain_once :radio_button_tag, :before_and_after
  alias_method_chain_once :submit_tag, :before_and_after
  alias_method_chain_once :image_submit_tag, :before_and_after
  
  private
  
  def with_before_and_after(object_name, method, options, &block)
    before = before(object_name, method, options)
    after = after(object_name, method, options)
    before + block.call + after
  end
  
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