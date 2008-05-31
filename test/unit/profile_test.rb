require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase
  
  context 'A Profile instance' do
    should_belong_to :user
    should_ensure_length_in_range :email, 3..100
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com', 'first.last+note@subdomain.example.com'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'is not a valid email address'
    should_require_unique_attributes :email
    should_allow_values_for :cell_carrier, nil, 'verizon', 'atandt', 't-mobile'
    should_not_allow_values_for :cell_carrier, 'foobar', :message => 'is not a valid cellular provider'
  end
  
  context 'An existing Profile' do
    setup do
      @profile = anybody.profile
    end
  end
  
end