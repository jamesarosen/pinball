ActiveRecord::Schema.define :version => 0 do
  create_table :users, :force => true do |t|
    t.column :email,    :string
    t.column :email2,   :string
    t.column :blog,     :string
    t.column :website,  :string
  end
end