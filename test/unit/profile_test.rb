require File.dirname(__FILE__) + '/../test_helper'

class ProfileTest < ActiveSupport::TestCase
  
  context 'The Profile class' do
    should 'parse cell phone numbers correctly' do
      assert_nil Profile.parse_cell_number(nil)
      assert_nil Profile.parse_cell_number('')
      assert_nil Profile.parse_cell_number('abcde')
      
      assert_equal 12345, Profile.parse_cell_number(12345)
      assert_equal 12345, Profile.parse_cell_number('12345')
      assert_equal 12345, Profile.parse_cell_number('1 2b3;4+5.')
    end
  end
  
  context 'A Profile instance' do
    should_belong_to :user
    should_ensure_length_in_range :email, 3..100
    should_allow_values_for :email, 'a@x.com', 'de.veloper@example.com', 'first.last+note@subdomain.example.com'
    should_not_allow_values_for :email, 'example.com', '@example.com', 'developer@example', 'developer', :message => 'is not a valid email address'
    should_require_unique_attributes :email
    should_allow_values_for :cell_carrier, nil, 'Verizon', 'AT&T'
    should_not_allow_values_for :cell_carrier, 'foobar', :message => 'is not a valid cellular provider'
  end
  
end