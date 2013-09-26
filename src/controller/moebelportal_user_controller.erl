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

-module(moebelportal_user_controller, [Req, SessionID]).
-compile(export_all).

type_locator() ->
	string:concat(topicmap_engine:base_locator(), "/types/user").

before_(Action) ->
	case Action of
		"create" -> 
			authentication:require_login(Req, SessionID);
		_ -> ok
		end.

list('GET', []) ->
    Users = boss_db:find(topic, [locators, 'contains', type_locator]),
    {ok, [{users, Users}]}.

login('GET', []) ->
    {ok, [{redirect, Req:header(referer)}]};

login('POST', []) ->
    Username = Req:post_param("username"),
	
    case boss_db:find(colosimo_user, [{username, Username}], 1) of
        [ColosimoUser] ->
            case ColosimoUser:check_password(Req:post_param("password")) of
                true ->
                   {redirect, proplists:get_value("redirect",
                       Req:post_params(), "/"), ColosimoUser:login_cookies()};
                false ->
                    {ok, [{error, "Authentication error"}]}
            end;
        [] ->
            {ok, [{error, "Authentication error"}]}
    end.

show('GET', [UserId]) ->
	case boss_db:find(UserId) of
		undefined ->
			{redirect, [{controller, "user"}, {action, "list"}]};
		User ->
			{ok, [{user, User}]}
	end.

create('GET', []) ->
    ok.