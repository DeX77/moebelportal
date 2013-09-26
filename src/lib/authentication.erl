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

-module(authentication).
-compile(export_all).

hash_password(Password)->
    bcrypt:hashpw(Password, bcrypt:gen_salt()).

require_login(Req, SessionID) ->
    case Req:cookie("user_id") of
        undefined -> need_login(SessionID); 
        Id ->
            case boss_db:find(Id) of
                undefined -> need_login(SessionID);
                UserTopic ->
                    case session_identifier(UserTopic) =:= Req:cookie("session_id") of
                        false -> need_login(SessionID);
                        true -> {ok, UserTopic}
                    end
            end
     end.

need_login(SessionID) ->
	boss_flash:add(SessionID, notice, "Need Login", "Poeser Pursche!!"),
	{redirect, "/login"}.
  
session_identifier(UserTopic) ->
  UserPwd = boss_db:find(occurrence, [{topic = UserTopic},
	{type = string:concat(topicmap_engine:base_locator(), "/types/user_password")}]),
  UserPwd:value().

