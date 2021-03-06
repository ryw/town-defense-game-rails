class AddOpenIdAuthenticationTables < ActiveRecord::Migration
  def self.up
    create_table "open_id_authentication_associations", :force => true do |t|
      t.column "server_url", :binary
      t.column "handle", :string
      t.column "secret", :binary
      t.column "issued", :integer
      t.column "lifetime", :integer
      t.column "assoc_type", :string
    end

    create_table "open_id_authentication_nonces", :force => true do |t|
      t.column "nonce", :string
      t.column "created", :integer
    end

    create_table "open_id_authentication_settings", :force => true do |t|
      t.column "setting", :string
      t.column "value", :binary
    end
    
    add_column :users, :identity_url, :string
  end

  def self.down
    drop_table "open_id_authentication_associations"
    drop_table "open_id_authentication_nonces"
    drop_table "open_id_authentication_settings"
    remove_column :users, :identity_url
  end
end