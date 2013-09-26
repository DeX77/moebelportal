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

-module(topicmap_engine).
-compile(export_all).

base_locator() ->
	case boss_db:count(topicmap)>0 of
		true ->
			TopicMap = boss_db:find(topicmap),
			"http://moebelportal.topicmapslab.de";
		false -> "http://moebelportal.topicmapslab.de"
	end.

topic_by_si(SubjectIdentifier) ->
	io:format("Suche nach SI: ~p~n", [SubjectIdentifier]),
	ListOfSIs = boss_db:find(subject_identifier, [{value, 'equals', SubjectIdentifier}]),

	case length(ListOfSIs) > 1 of
		true ->
			io:format("Mehr als ein Topic mit SI gefunden!?~n");
		false ->
			SI = lists:last(ListOfSIs),
			case SI /= undefined of
				true ->
					io:format("SI gefunden: ~p~n", [SI]),
					SI:topic();
				false ->
					[]
			end
	end.

topic_by_ii(ItemIdentifier)->
	io:format("Suche nach II: ~p~n", [ItemIdentifier]),
	ListOfIIs = boss_db:find(item_identifier, [{value, 'equals', ItemIdentifier}]),

	case length(ListOfIIs) /= 1 of
		true ->
			io:format("Falsche II Zahl~n"),
			[];
		false ->
			II = lists:last(ListOfIIs),
			case II /= undefined of
				true ->
					io:format("ItemIdentifier gefunden: ~p~n", [II]),
					II:topic();
				false ->
					[]
			end
	end.

type_roles(Topic) ->
	%get the type role topic
	Topic_TypeInstance_Type = topic_by_si("http://psi.topicmaps.org/iso13250/model/type"),

	%get the role of type-instance-type with player this topic
	io:format("Suche Typ Rollen ~p~n",[Topic_TypeInstance_Type]),
	{topic,Topic_TypeInstance_TypeID,_,_} =Topic_TypeInstance_Type,
	{topikc,TopicId,_,_} = Topic,
	io:format("Anfrage: boss_db:find(role, [{type_id, equals, ~p},
						{player_id, equals, ~p}]).~n",[Topic_TypeInstance_TypeID, TopicId]),
	boss_db:find(role, [{type_id, equals, Topic_TypeInstance_TypeID},
						{player_id, equals, TopicId}]).


instance_roles(Topic) ->
	%get the instance role topic
	Topic_TypeInstance_Instance = topic_by_si("http://psi.topicmaps.org/iso13250/model/instance"),

	%get the role of type-instance-instance with player this topic
	io:format("Suche Instanz Rollen~n"),
	{topic,Topic_TypeInstance_InstanceID,_,_} =Topic_TypeInstance_Instance,
	{topic,TopicId,_,_} = Topic,
	io:format("Anfrage: boss_db:find(role, [{type_id = ~p},
									{player_id = ~p}]).~n",[Topic_TypeInstance_InstanceID, TopicId]),

	boss_db:find(role, [{type_id = Topic_TypeInstance_InstanceID},
									{player_id = TopicId}]).

instances(Topic) ->
	%get the association type topic
	Topic_TypeInstance_Assoc = topic_by_si("http://psi.topicmaps.org/iso13250/model/type-instance"),

	%get all associations of type-instance type with the correct roles
	Type_roles = type_roles(Topic),

	io:format("Typ Rollen: ~p~n",[Type_roles]),


	case Type_roles /= [] of
		true ->
			TypeInstanceAssocs = boss_db:find(association, [{topic = Topic_TypeInstance_Assoc},
													{roles, 'contains_any', Type_roles}]);
		false ->
			TypeInstanceAssocs = []
	end,

	%get all roles in these associations that are instances
	case TypeInstanceAssocs /= [] of
		true ->
			Instances_roles = TypeInstanceAssocs:roles() -- Type_roles;
		false ->
			Instances_roles = []
	end,

	%get all topics for these instances
	Instances_lists = lists:map(fun(Role) -> Role:topic() end, Instances_roles),
	io:format("Instanzen gefunden!! : ~p~n", [Instances_lists]),
	lists:flatten(Instances_lists).

topics_with_equal_identifier(Topic) ->
	SIValues = lists:map(fun (SI) ->
					   SI:value()
			  end, Topic:subject_identifiers()),
	SIs = boss_db:find(subject_identifier, [{topic_id, 'not_equals', Topic:id()},
											{value, 'not_equals', []},
											{value, 'contains_any', SIValues}]),
 	lists:map(fun (SI) ->
 					   SI:topic()
 			  end, SIs).


replace_topics_in_information_items(OldTopic, NewTopic) ->
	io:format("Replacing OldTopic in name scopes~n"),
	%% 	[topics],
	%%  [scope],
	NameScopesWithOldTopic = boss_db:find(name_scope, [{topic_id, equals, OldTopic:id()}]),
	io:format("Relevant Scopes: ~p~n", [NameScopesWithOldTopic]),

	lists:foreach(fun (NameScope)->
						   NameId = NameScope:name_id(),
						   NameScope:delete(),
						   NS = object_scope:new(id, NameId, NewTopic:id()),
						   NS:save()
				  end, NameScopesWithOldTopic),
	io:format("OldTopic replaced in name scopes~n"),


	OccurrencesScopesWithOldTopic = boss_db:find(occurrence_scope, [{topic_id, equals, OldTopic:id()}]),
	io:format("Relevant Scopes: ~p~n", [OccurrencesScopesWithOldTopic]),

	lists:foreach(fun (OccurrenceScope)->
						   OccId = OccurrenceScope:occurrence_id(),
						   OccurrenceScope:delete(),
						   OS = occurrence_scope:new(id, OccId, NewTopic:id()),
						   OS:save()
				  end, OccurrencesScopesWithOldTopic),
	io:format("OldTopic replaced in occurrence scopes~n"),

	%% 	[type],
	OccurrencesWithTypeOldTopic = boss_db:find(occurrence, [{type_id, 'equals', OldTopic:id()}]),
	lists:foreach(fun (TypedItem) ->
						   TypedItem:set(type, NewTopic),
						   TypedItem:save()
				  end, OccurrencesWithTypeOldTopic),
	io:format("OldTopic replaced as type ~n"),

	%% 	[player], and
 	RolesWithPlayerOldTopic = boss_db:find(role, [{player_id, 'equals', OldTopic:id()}]),
	lists:foreach(fun (Role) ->
						   Role:set(player_id, NewTopic:id()),
						   Role:save()
				  end, RolesWithPlayerOldTopic),
	io:format("OldTopic replaced as player scopes~n"),


	%% 	[reifier].
	TopicMapsWithReifierOldTopic = boss_db:find(topicmap, [{reifier_id, 'equals', OldTopic:id()}]),
	lists:foreach(fun (Item) ->
						   Item:set(reifier_id, NewTopic:id()),
						   Item:save()
				  end, TopicMapsWithReifierOldTopic),
	io:format("OldTopic replaced as topicmap reiifier scopes~n"),


	AssosciationsWithReifierOldTopic = boss_db:find(assosciation, [{reifier_id, 'equals', OldTopic:id()}]),
	lists:foreach(fun (Item) ->
						   Item:set(reifier_id, NewTopic:id()),
						   Item:save()
				  end, AssosciationsWithReifierOldTopic),
	io:format("OldTopic replaced as assosciation reiifier scopes~n").




merge_value_items(ListA, ListB) ->
	SortedItemsTopicA = lists:usort(fun (ItemA, ItemB) ->
									string:equal(ItemA:value(),ItemB:value())
									end, ListA),
	SortedItemsTopicB = lists:usort(fun (ItemA, ItemB) ->
									string:equal(ItemA:value(),ItemB:value())
									end, ListB),
	MergedItemsTopicATopicB = lists:umerge(fun (ItemA, ItemB) ->
									string:equal(ItemA:value(),ItemB:value())
									end, SortedItemsTopicA, SortedItemsTopicB),
	MergedItemsTopicATopicB.



merge_topics(TopicA, TopicB) ->
	%Create a new topic item C.
	TopicC = topic:new(id, TopicA:topicmap_id(), "",""),
	io:format("TopicC created~n"),


	%% 	Replace A by C wherever it appears in one of the following properties
	%% 	of an information item:
	replace_topics_in_information_items(TopicA, TopicC),
	io:format("TopicA ~p replaced~n",[TopicA]),


	%% 	Repeat for B.
	replace_topics_in_information_items(TopicB, TopicC),
	io:format("TopicB ~p replaced~n", [TopicB]),

	io:format("New topic saved: ~p~n", [TopicC:save()]),

	%% 	Set C's [topic names] property to the union of the values of
	%% 	A and B's [topic names] properties.
	MergedNamesTopicATopicB = merge_value_items(TopicA:names(), TopicB:names()),
	lists:foreach(fun (Name)->
						   Name:set(parent_id, TopicC:id())
				  end, MergedNamesTopicATopicB),
	io:format("Unions of names set ~n"),

	%% Set C's [occurrences] property to the union of the values of A and B's
	%% [occurrences] properties.
	MergedOccurrencesTopicATopicB = merge_value_items(TopicA:occurrences(),
														TopicB:occurrences()),
	lists:foreach(fun (Occ)->
						   Occ:set(parent_id, TopicC:id())
				  end, MergedOccurrencesTopicATopicB),
	io:format("Unions of occurrences set ~n"),

	%% Set C's [subject identifiers] property to the union of the values of
	%% A and B's [subject identifiers] properties.
	MergedSubjectIdentifierTopicATopicB =
	merge_value_items(TopicA:subject_identifiers(), TopicB:subject_identifiers()),
		lists:foreach(fun (SI)->
						   SI:set(topic_id, TopicC:id())
				  end, MergedSubjectIdentifierTopicATopicB),
	io:format("Unions of subject identifiers set ~n"),

	%% Set C's [subject locators] property to the union of the values of
	%% A and B's [subject locators] properties.
	MergedSubjectLocatorsTopicATopicB =
	merge_value_items(TopicA:subject_locators(), TopicB:subject_locators()),
	lists:foreach(fun (SL)->
						   SL:set(topic_id, TopicC:id())
				  end, MergedSubjectLocatorsTopicATopicB),
	io:format("Unions of subject locators set ~n"),

	%% Set C's [item identifiers] property to the union of the values of
	%% A and B's [item identifiers] properties.
	MergedItemIdentifiersTopicATopicB =
	merge_value_items(TopicA:item_identifiers(), TopicB:item_identifiers()),
		lists:foreach(fun (II)->
						   II:set(topic_id, TopicC:id())
				  end, MergedItemIdentifiersTopicATopicB),
	io:format("Unions of item_identifiers set ~n"),

	boss_db:delete(TopicA:id()),
	boss_db:delete(TopicB:id()),

	io:format("Topic merged~n"),

	ok.





