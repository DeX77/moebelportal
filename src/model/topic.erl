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


-module(topic, [Id, TopicmapId]).
-compile(export_all).

-belongs_to(topicmap).

-has({subject_identifiers, many}).
-has({subject_locators, many}).
-has({item_identifiers, many}).
-has({names, many}).
-has({occurrences, many}).

default_label() ->
	case lists:last(names) of
		undefined -> Id;
	LastOfNames ->
		LastOfNames:value()
	end.

locators() ->
	topicmap_engine:merge_value_items(subject_identifiers,
		topicmap_engine:merge_value_items(subject_locators, item_identifiers)).

after_create() ->
	case boss_db:count(item_identifier, [{value, equals, Id}]) > 0 of
		true ->
			ok;
		false ->
			II = item_identifier:new(id, Id, TopicmapId, Id),
			II:save()
	end.

before_delete() ->
	%remove subject_identifiers
	SI = boss_db:find(subject_identifer, [{topic_id, equals, Id}]),
	SI:delete(),

	%rempve subject locators
	SL = boss_db:find(subject_locator, [{topic_id, equals, Id}]),
	SL:delete(),

	%remove item identifiers
	II = boss_db:find(item_identifier, [{topic_id, equals, Id}]),
	II:delete().

