require File.dirname(__FILE__) + '/../test_helper'

class FavoriteLocationTest < ActiveSupport::TestCase
  
  def self.model_class; Location::Favorite; end
  
  def setup
    @somebody = Profile.find(:first)
    assert_not_nil @somebody
    @somewhere = Location::Address.find(:first)
    assert_not_nil @somewhere
  end
    
  def new_favorite(args = {})
    Location::Favorite.new({
      :name => 'downtown',
      :location => @somewhere,
      :profile => @somebody
    }.merge(args))
  end
  
  context 'A new Favorite Location' do
    
    should 'require a name' do
      f = new_favorite(:name => nil)
      assert !f.valid?
      assert f.errors.on(:name)
    end
    
    should 'require a unique name' do
      new_favorite.save!
      f = new_favorite
      assert !f.valid?
      assert f.errors.on(:name)
    end
    
    should 'require a profile' do
      f = new_favorite(:profile => nil)
      assert !f.valid?
      assert f.errors.on(:profile_id)
    end

    should 'require a location' do
      f = new_favorite(:location => nil)
      assert !f.valid?
      assert f.errors.on(:location_id)
    end
    
    should 'be valid with a name, profile, and location' do
      f = new_favorite
      assert f.valid?, f.errors.inspect
    end
    
    should 'be valid with a location as a String to be parsed' do
      f = new_favorite(:location => 'BOS')
      assert f.valid?, f.errors.inspect
      assert f.location.kind_of?(Location::Airport)
      assert_equal 'BOS', f.location.address
    end
    
  end
  
end