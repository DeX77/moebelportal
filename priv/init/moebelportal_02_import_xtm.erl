%%  Copyright (C) 2012  Daniel Exner  <dex@dragonslave.de>
%%
%%  This program is free software; you can redistribute it
%%  and/or modify it under the terms of the GNU General Public License as published
%%  by the Free Software Foundation; either version 2 of the License, or
%%  (at your option) any later version.
%%
%%  This program is distributed in the hope that it will be useful, but WITHOUT ANY
%%  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
%%  PARTICULAR PURPOSE. See the GNU General Public License for more details.
%%
%%  You should have received a copy of the GNU General Public License along with
%%  this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
%%  St, Fifth Floor, Boston, MA 02110, USA

-module(moebelportal_02_import_xtm).
-export([init/0]).
-include("xtm.hrl").

init() ->
  %% Read TM from XTM2
  {ok, IkeaTM} = file:read_file("Model/ikeatm.xtm2"),
  %% Create Model from XTM XSD
  {ok, XTM2Model} = erlsom:compile_xsd_file("xtm.xsd"),

  %% Import TopicMap
  {ok, ImportResults, _} = erlsom:scan(IkeaTM, XTM2Model),

  import_tm_into_db(ImportResults).

import_tm_into_db(ImportResults) ->

  % Save it
  TheTopicMap = topicmap:new(id, ImportResults#'topicMap'.'reifier'),
  {ok, TM} = TheTopicMap:save(),

  io:format("Created new TM with ID=~s~n", [TM:id()]),

  TopicRecords = [{import_topic_into_db(Topic, TM:id())} ||
    Topic <- ImportResults#'topicMap'.topicsandassosciations, is_record(Topic, topic)],

  AssosciationRecords = [{import_assosciation_into_db(Assosciation, TM:id())} ||
    Assosciation <- ImportResults#'topicMap'.topicsandassosciations, is_record(Assosciation, association)],

  io:format("Created Assosciations~n"),

  {ok, []}.

import_topic_into_db(#topic{} = Topic, TopicmapId) ->
  TopicRecord = find_or_create_topic_by_ii(Topic#'topic'.'id', TopicmapId),

  if is_record(Topic#'topic'.'instanceOf', instanceOf) ->
    TypeRecords = [{create_type_instance_realtionship(TopicRecord:id(), TopicmapId, InstanceOf)} ||
      InstanceOf <- Topic#'topic'.'instanceOf'#'instanceOf'.'topicRef', is_record(InstanceOf, topicRef)];
    true -> ok
  end,

  IdentifierRecords = [{add_identifier_to_object(TopicRecord:id(), Identifier, TopicmapId)} ||
    Identifier <- Topic#'topic'.identifier],

  OccurrencesRecords = [{add_occurrence(Occurrence, TopicRecord:id(), TopicmapId)} ||
    Occurrence <- Topic#'topic'.occurrencesandnames, is_record(Occurrence, occurrence)],

  NameRecords = [{add_name(Name, TopicRecord:id(), TopicmapId)} ||
    Name <- Topic#'topic'.occurrencesandnames, is_record(Name, name)],

  TopicRecord:save().

add_identifier_to_object(ObjectId, Identifier, TopicmapId) ->
  if is_record(Identifier, subjectIdentifier) -> add_subjectIdentifier_to_object(ObjectId, Identifier);
    is_record(Identifier, subjectLocator) -> add_subjectLocator_to_object(ObjectId, Identifier);
    is_record(Identifier, itemIdentity) -> add_itemIdentity_to_object(ObjectId, Identifier, TopicmapId)
  end.

add_subjectIdentifier_to_object(ObjectId, Identifier) ->
  IdentifierRecord = subject_identifier:new(id, ObjectId, Identifier#subjectIdentifier.'href'),
  IdentifierRecord:save().

add_subjectLocator_to_object(ObjectId, Identifier) ->
  IdentifierRecord = subject_locator:new(id, ObjectId, Identifier#subjectLocator.'href'),
  IdentifierRecord:save().

add_itemIdentity_to_object(ObjectId, Identifier, TopicmapId) ->
  IdentifierRecord = item_identifier:new(id, ObjectId, TopicmapId, Identifier#itemIdentity.'href'),
  IdentifierRecord:save().

import_subject_identifier_into_db(SubjectIdentifier, TopicId) ->
  SI = subject_identifier:new(id, TopicId, SubjectIdentifier),
  SI:save().

import_subject_locator_into_db(SubjectLocator, TopicId) ->
  SL = subject_locator:new(id, TopicId, SubjectLocator),
  SL:save().

import_item_identity_into_db(ItemIdentity, TopicId, TopicMapId) ->
  II = item_identifier:new(id, TopicId, TopicMapId, ItemIdentity),
  II:save().

add_occurrence(Occurrence, CleanId, TopicmapId) ->
  Type = find_or_create_topic_by_ii(Occurrence#'occurrence'.'type'#type.'topicRef'#'topicRef'.'href', TopicmapId),
  TypeId = Type:id(),
  [Value] = Occurrence#'occurrence'.value#'any-markup'.any,

  if Occurrence#'occurrence'.'reifier' /= undefined ->
    Reifier = find_or_create_topic_by_ii(Occurrence#'occurrence'.'reifier', TopicmapId),
    ReifierId = Reifier:id(),
    OccurrenceRecord = occurrence:new(id, CleanId, TypeId, ReifierId, Occurrence#'occurrence'.value#'any-markup'.'datatype', Value);
    true -> OccurrenceRecord = occurrence:new(id, CleanId, TypeId, "", Occurrence#'occurrence'.value#'any-markup'.'datatype', Value)
  end,

  OccurrenceRecord:save().

add_name(Name, CleanId, TopicmapId) ->

  if Name#'name'.'type' /= undefined ->
    Type = find_or_create_topic_by_ii(Name#'name'.'type'#type.'topicRef'#'topicRef'.'href', TopicmapId),
    TypeId = Type:id();
    true -> TypeId = ""
  end,

  if Name#'name'.'reifier' /= undefined ->
    Reifier = find_or_create_topic_by_ii(Name#'name'.'reifier', TopicmapId),
    ReifierId = Reifier:id(),
    NameRecord = name:new(id, CleanId, ReifierId, TypeId, Name#'name'.'value');
    true -> NameRecord = name:new(id, CleanId, "", TypeId, Name#'name'.'value')
  end,

  if Name#'name'.'itemIdentity' /= undefined ->
    IdentifierRecords = [{import_item_identity_into_db(NameRecord:id(), Identifier, TopicmapId)} ||
      Identifier <- Name#'name'.'itemIdentity'];
    true -> ok
  end,

  if Name#'name'.'scope' /= undefined ->
    NameScopeRecords = [{add_scope(NameRecord:id(), TopicId, TopicmapId)} ||
      TopicId <- Name#'name'.'scope'#'scope'.'topicRef'];
    true -> ok
  end,

  if Name#'name'.'variant' /= undefined ->
    NameVariantRecords = [{add_variant(CleanId, Variant, TopicmapId)} ||
      Variant <- Name#'name'.'variant'];
    true -> ok
  end,

  NameRecord:save().

add_scope(ObjectId, TopicId, TopicMapId) ->
  Clean = find_or_create_topic_by_ii(TopicId#'topicRef'.'href', TopicMapId),
  CleanId = Clean:id(),
  ScopeRecord = object_scope:new(id, ObjectId, CleanId),
  ScopeRecord:save().

add_variant(ObjectId, Variant, TopicmapId) ->
  [Value] = Variant#'variant'.value#'any-markup'.any,

  if Variant#'variant'.'reifier' /= undefined ->
    Reifier = find_or_create_topic_by_ii(Variant#'variant'.'reifier', TopicmapId),
    ReifierId = Reifier:id(),
    VariantRecord = variant:new(id, ObjectId, ReifierId, Value);
    true -> VariantRecord = variant:new(id, ObjectId, "", Value)
  end,

  if Variant#'variant'.'itemIdentity' /= undefined ->
    IdentifierRecords = [{import_item_identity_into_db(VariantRecord:id(), Identifier, TopicmapId)} ||
      Identifier <- Variant#'variant'.'itemIdentity'];
    true -> ok
  end,

  if Variant#'variant'.'scope' /= undefined ->
    NameScopeRecords = [{add_scope(VariantRecord:id(), TopicId, TopicmapId)} ||
      TopicId <- Variant#'variant'.'scope'#'scope'.'topicRef'];
    true -> ok
  end,

  VariantRecord:save().


import_assosciation_into_db(#association{} = Assosciation, TopicmapId) ->
  Type = find_or_create_topic_by_ii(Assosciation#'association'.'type'#type.'topicRef'#'topicRef'.'href', TopicmapId),
  TypeId = Type:id(),

  if Assosciation#'association'.'reifier' /= undefined ->
    Reifier = find_or_create_topic_by_ii(Assosciation#'association'.'reifier', TopicmapId),
    ReifierId = Reifier:id(),
    AssosciationRecord = association:new(id, TopicmapId, TypeId, ReifierId);
    true -> AssosciationRecord = association:new(id, TopicmapId, TypeId, "")
  end,

  if Assosciation#'association'.'itemIdentity' /= undefined ->
    add_itemIdentity_to_object(AssosciationRecord:id(), Assosciation#'association'.'itemIdentity', TopicmapId);
    true -> ok
  end,

  if Assosciation#'association'.'scope' /= undefined ->
    AssosciationScopeRecords = [{add_scope(AssosciationRecord:id(), TopicId, TopicmapId)} ||
      TopicId <- Assosciation#'association'.'scope'#'scope'.'topicRef'];
    true -> ok
  end,

  if Assosciation#'association'.'role' /= undefined ->
    RoleRecords = [{add_role(AssosciationRecord:id(), Role, TopicmapId)} ||
      Role <- Assosciation#'association'.'role'];
    true -> ok
  end,

  AssosciationRecord:save().

add_role(AssosciationId, Role, TopicmapId) ->
  RoleType = find_or_create_topic_by_ii(Role#'role'.'type'#'type'.'topicRef'#'topicRef'.'href', TopicmapId),
  RoleTypeId = RoleType:id(),
  Player = find_or_create_topic_by_ii(Role#'role'.'topicRef'#'topicRef'.'href', TopicmapId),
  PlayerId = Player:id(),

  if Role#'role'.'reifier' /= undefined ->
    Reifier = find_or_create_topic_by_ii(Role#'role'.'reifier', TopicmapId),
    ReifierId = Reifier:id(),
    RoleRecord = role:new(id, AssosciationId, ReifierId, RoleTypeId, PlayerId);
    true -> RoleRecord = role:new(id, AssosciationId, "", RoleTypeId, PlayerId)
  end,

  if Role#'role'.'itemIdentity' /= undefined ->
    add_itemIdentity_to_object(RoleRecord:id(), Role#'role'.'itemIdentity', TopicmapId);
    true -> ok
  end,


  RoleRecord:save().

create_type_instance_realtionship(ObjectId, TopicmapId, InstanceOf) ->

  HrefTopic = find_or_create_topic_by_ii(InstanceOf#'topicRef'.'href', TopicmapId),
  Href = HrefTopic:id(),

  TypeInstanceTopic = find_or_create_topic_by_si("http://psi.topicmaps.org/iso13250/model/type-instance", TopicmapId),
  AssociationType = #'type'{'topicRef' =
  #topicRef{
    href = TypeInstanceTopic:id()
  }
  },
  InstanceTopic = find_or_create_topic_by_si("http://psi.topicmaps.org/iso13250/model/instance", TopicmapId),
  InstanceRoleType = #'type'{'topicRef' =
  #topicRef{
    href = InstanceTopic:id()
  }
  },
  TypeTopic = find_or_create_topic_by_si("http://psi.topicmaps.org/iso13250/model/type", TopicmapId),
  TypeRoleType = #'type'{'topicRef' =
  #topicRef{href = TypeTopic:id()
  }
  },

  Assosciation = #association{
    'type' = AssociationType,
    'role' = [
      #'role'{
        type = InstanceRoleType,
        topicRef = #'topicRef'{'href' = ObjectId}
      },
      #'role'{
        type = TypeRoleType,
        topicRef = #'topicRef'{'href' = Href}
      }]
  },

  import_assosciation_into_db(Assosciation, TopicmapId).


find_or_create_topic_by_si(Si, TopicmapId) ->
  SiRecord = boss_db:find(subject_identifier, [{value, 'equals', "Si"}]),

  if SiRecord /= [] ->
    TopicBySI = SiRecord:topic();
    true -> TopicBySIRecord = topic:new(id, TopicmapId),
      {ok, TopicBySI} = TopicBySIRecord:save(),
      SiRecordNew = subject_identifier:new(id, TopicBySI:id(), Si),
      SiRecordNew:save()
  end,

  TopicBySI.

find_or_create_topic_by_ii(Ii, TopicmapId) ->
  IiRecord = boss_db:find(item_identifier, [{value, 'equals', "Ii"}]),

  if IiRecord /= [] ->
    TopicByIi = IiRecord:topic();
    true -> TopicByIIRecord = topic:new(id, TopicmapId),
      {ok, TopicByIi} = TopicByIIRecord:save(),
      IiRecordNew = item_identifier:new(id, TopicByIi:id(), TopicmapId, Ii),
      IiRecordNew:save()
  end,

  TopicByIi.
