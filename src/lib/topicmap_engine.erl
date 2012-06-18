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
			TopicMap = boss_db:first_topicmap(),
			TopicMap:id();
		false -> "http://moebelportal.topicmapslab.de"
	end.

topic_by_si(SubjectIdentifier) ->
	SI = boss_db:find(SubjectIdentifier),
	case SI /= undefined of
		true ->
			SI:topic();
		false ->
			[]
	end.

type_roles(Topic) ->
	%get the type role topic
	Topic_TypeInstance_Type = topic_by_si("http://psi.topicmaps.org/iso13250/model/type"),
	
	case Topic_TypeInstance_Type /= [] of
		true ->
			%get the role of type-instance-type with player this topic
			boss_db:find(role, [{topic = Topic_TypeInstance_Type},
									{players, 'contains', Topic}]);
		false ->
			[]
	end.

instance_roles(Topic) ->
	%get the instance role topic
	Topic_TypeInstance_Instance = topic_by_si("http://psi.topicmaps.org/iso13250/model/instance"),
	
	%get the role of type-instance-instance with player this topic
	boss_db:find(role, [{topic = Topic_TypeInstance_Instance},
									{players, 'contains', Topic}]).

instances(Topic) ->	
	%get the association type topic
	Topic_TypeInstance_Assoc = topic_by_si("http://psi.topicmaps.org/iso13250/model/type-instance"),
	
	%get all associations of type-instance type with the correct roles
	Type_roles = type_roles(Topic),
	
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
	lists:flatten(Instances_lists).

	
	
	 