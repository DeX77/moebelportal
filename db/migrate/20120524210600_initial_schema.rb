# Copyright: Copyright 2009 Topic Maps Lab, University of Leipzig.
# License:   Apache License, Version 2.0

require 'active_record'

      class InitialSchema < ::ActiveRecord::Migration
        def self.up
          create_table :topic_maps do |t|
            t.column :base_locator, :string, :null => false
          end
          create_table :topics do |t|
            t.column :topic_map_id, :integer, :null => false
            t.column :reified_id, :integer
            t.column :reified_type, :string
          end
          create_table :associations do |t|
            t.column :topic_map_id, :integer, :null => false
            t.column :ttype_id, :integer
          end
          create_table :roles do |t|
            t.column :association_id, :integer, :null => false
            t.column :ttype_id, :integer
            t.column :topic_id, :integer
          end
          create_table :names do |t|
            t.column :topic_id, :integer, :null => false
            t.column :ttype_id, :integer
            t.column :value, :string
          end
          create_table :occurrences do |t|
            t.column :topic_id, :integer, :null => false
            t.column :ttype_id, :integer
            t.column :value, :text
            t.column :datatype, :string
          end
          create_table :variants do |t|
            t.column :name_id, :integer, :null => false
            t.column :value, :text
            t.column :datatype, :string
          end
          create_table :item_identifiers do |t|
            t.column :topic_map_id, :integer, :null => false
            t.column :reference, :string, :null => false
            t.column :construct_id, :integer
            t.column :construct_type, :string
          end
          create_table :subject_identifiers do |t|
            t.column :topic_map_id, :integer, :null => false
            t.column :reference, :string, :null => false
            t.column :topic_id, :integer
          end
          create_table :subject_locators do |t|
            t.column :topic_map_id, :integer, :null => false
            t.column :reference, :string, :null => false
            t.column :topic_id, :integer
          end
          create_table :scoped_objects_topics do |t|
            t.column :scoped_object_id, :integer
            t.column :scoped_object_type, :string
            t.column :topic_id, :integer
          end
#          execute("
#            create view associations_rolecount as
#              select a.id as id, a.topic_map_id as topic_map_id, a.ttype_id as ttype_id, count(a.id) as rcnt
#                from associations a inner join association_roles r1 on a.id == r1.association_id;
#          ")
#
#          execute("
#            create view associations_cache as
#              select distinct
#                 a.id as id,  a.topic_map_id, a.ttype_id, a.rcnt,
#                 r1.id as role1_id, r1.ttype_id as type1_id, r1.topic_id as player1_id,
#                 r2.id as role2_id, r2.ttype_id as type2_id, r2.topic_id as player2_id
#              from associations_rolecount a
#                inner join association_roles r1 on a.id == r1.association_id
#                inner join association_roles r2 on a.id == r2.association_id
#              where r1.id != r2.id;
#          ")
#          execute("
#            create view associationcache as
#              select distinct
#                 a.id as association_id,  a.topic_map_id, a.ttype_id,
#                 r1.id as association_role1_id, r1.ttype_id as role_type1_id, r1.topic_id as player1_id,
#                 r2.id as association_role2_id, r2.ttype_id as role_type2_id, r2.topic_id as player2_id
#              from associations a
#                inner join association_roles r1 on a.id == r1.association_id
#                inner join association_roles r2 on a.id == r2.association_id
#              where r1.id != r2.id
#            ")
        end

        def self.down
          drop_table :topic_maps
          drop_table :topic
          drop_table :associations
          drop_table :roles
          drop_table :names
          drop_table :occurrences
          drop_table :variants
          drop_table :scoped_objects_topics
        end

      end
