class Alpha < ActiveRecord::Migration
  def self.up
    create_table 'users', :force => true do |t|
      t.string    'login',                    :limit => 40, :nil => false
      t.string    'crypted_password',         :limit => 40, :nil => false
      t.string    'salt',                     :limit => 40, :nil => false
      t.string    'remember_token'
      t.datetime  'remember_token_expires_at'
      t.boolean   'is_admin',                 :default => false
      t.string    'email_verification'
      t.boolean   'email_verified',           :default => false
      t.timestamps
    end

    add_index 'users', ['login'], :name => 'index_users_on_login'
    
    create_table 'profiles', :force => true do |t|
      t.belongs_to  :user
      t.string      'display_name'
      t.text        'description'
      t.string      'email',                  :nil => false
      t.string      'cell_number'
      t.string      'cell_carrier'
      t.belongs_to  :location
      t.timestamps
    end

    add_index "profiles", "user_id"

    create_table :locations do |t|
      t.string    'display_name',             :nil => false
      t.string    'location_type',            :nil => false
      t.decimal   'latitude',                 :precision => 11, :scale => 9  #  xy.abcdefghi
      t.decimal   'longitude',                :precision => 12, :scale => 9  # xyz.abcdefghi
      t.timestamps
    end
    
    create_table "friends", :force => true do |t|
      t.belongs_to  :inviter,                 :nil => false
      t.belongs_to  :invitee,                 :nil => false
      t.integer     'status',                 :default => 0
      t.integer     'tier',                   :nil => false, :default => 3
      t.timestamps
    end

    add_index "friends", ["inviter_id", "invitee_id"], :name => "index_friends_on_inviter_id_and_invitee_id", :unique => true
    add_index "friends", ["invitee_id", "inviter_id"], :name => "index_friends_on_invitee_id_and_inviter_id", :unique => true
  end

  def self.down
    drop_table :friends
    drop_table :locations
    drop_table :profiles
    drop_table :users
  end
end
