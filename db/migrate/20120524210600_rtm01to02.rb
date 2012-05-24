class Rtm01to02 < ActiveRecord::Migration
  def self.up
    rename_table :association_roles, :roles
    rename_table :topic_names, :names
    rename_column :variants, :topic_name_id, :name_id
    rename_column :item_identifiers, :topic_map_construct_id, :construct_id
    rename_column :item_identifiers, :topic_map_construct_type, :construct_type
  end

  def self.down
    rename_table :roles, :association_roles
    rename_table :names, :topic_names
    rename_column :variants, :name_id, :topic_name_id
    rename_column :item_identifiers, :construct_id, :topic_map_construct_id
    rename_column :item_identifiers, :construct_type, :topic_map_construct_type
  end
end