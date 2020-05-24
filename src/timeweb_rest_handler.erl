%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 22. май 2020 23:58
%%%-------------------------------------------------------------------
-module(timeweb_rest_handler).
-author("GRECHNEVAV").

-include("timeweb.hrl").

-export([init/2]).
-export([content_types_provided/2, content_types_accepted/2, allowed_methods/2, is_authorized/2]).
-export([handle_request/2]).

init(Req, Opts) ->
  {cowboy_rest, Req, Opts}.

allowed_methods(Req, State) ->
  Methods = [<<"GET">>, <<"POST">>, <<"PUT">>],
  {Methods, Req, State}.

is_authorized(Req, #{request_name := RequestName} = State) when RequestName == register; RequestName == signin ->
  {true, Req, State};
is_authorized(Req, State) ->
  case cowboy_req:parse_header(<<"authorization">>, Req) of
    {basic, Login, Token} ->
      case gen_server:call(timeweb_users_mgr, {is_authorized, Login, Token}) of
        true ->
          State2 = maps:put(login, Login, State),
          {true, Req, State2};
        false ->
          {{false,  <<"Basic realm=\"cowboy\"">>}, Req, State}
      end;
    _ ->
      {{false,  <<"Basic realm=\"cowboy\"">>}, Req, State}
  end.

content_types_provided(Req, State) ->
  {[
    {<<"application/json">>, handle_request}
  ], Req, State}.

content_types_accepted(Req, State) ->
  {[
    {<<"application/json">>, handle_request}
  ], Req, State}.

handle_request(Req, State) ->
  Method = cowboy_req:method(Req),
  {ok, RawBody, _} = cowboy_req:read_body(Req),
   Body = case RawBody of
           <<>>    -> #{};
           RawBody -> timeweb_utils:json_decode(RawBody)
         end,
  Response = handle_request(Method, State, Body),
  case Method of
    <<"GET">> ->
      {jsone:encode(Response), Req, State};
    _ ->
      Req2 = cowboy_req:set_resp_body(jsone:encode(Response), Req),
      {true, Req2, State}
  end.

handle_request(<<"GET">>, #{request_name := users_list}, _) ->
  case timeweb_db:get_all_users() of
    {ok, Users} ->
      Users;
    {error, ?ERROR_INTERNAL_DB_ERROR_CODE} ->
      ?API_ERROR(?ERROR_INTERNAL_DB_ERROR_CODE, ?ERROR_INTERNAL_DB_ERROR_DESCR)
  end;
handle_request(<<"POST">>, #{request_name := register},
    #{<<"login">> := Login, <<"password">> := Password, <<"user_name">> := UserName}) ->
  case timeweb_db:register_user(Login, Password, UserName) of
    {ok, UserId} ->
      #{user_id => UserId};
    {error, ?ERROR_CANNOT_REGISTER_CODE} ->
      ?API_ERROR(?ERROR_CANNOT_REGISTER_CODE, ?ERROR_CANNOT_REGISTER_DESCR)
  end;
handle_request(<<"POST">>, #{request_name := signin},
    #{<<"login">> := Login, <<"password">> := Password}) ->
  case timeweb_db:get_user(Login, Password) of
    {ok, User} ->
      case gen_server:call(timeweb_users_mgr, {signin_user, User}) of
        {ok, Token} ->
          #{user => User, token => Token};
        {error, ?ERROR_CANNOT_CREATE_USER_SESSION_CODE} ->
          ?API_ERROR(?ERROR_CANNOT_CREATE_USER_SESSION_CODE, ?ERROR_CANNOT_CREATE_USER_SESSION_DESCR)
      end;
    {error, ?ERROR_WRONG_LOGIN_PASSWORD_CODE} ->
      ?API_ERROR(?ERROR_WRONG_LOGIN_PASSWORD_CODE, ?ERROR_WRONG_LOGIN_PASSWORD_DESCR)
  end;
handle_request(<<"POST">>, #{request_name := change_password},
    #{<<"new_password">> := OldPassword, <<"old_password">> := OldPassword}) ->
  ?API_ERROR(?ERROR_CANNOT_CHANGE_SAME_PASSWORD_CODE, ?ERROR_CANNOT_CHANGE_SAME_PASSWORD_DESCR);
handle_request(<<"POST">>, #{request_name := change_password, login := Login},
    #{<<"new_password">> := NewPassword, <<"old_password">> := OldPassword}) ->
  case timeweb_db:change_password(Login, NewPassword, OldPassword) of
    ok ->
      #{result => <<"changed">>};
    {error, ?ERROR_INVALID_OLD_PASSWORD_CODE} ->
      ?API_ERROR(?ERROR_INVALID_OLD_PASSWORD_CODE, ?ERROR_INVALID_OLD_PASSWORD_DESCR)
  end;
handle_request(_, _, _) ->
  ?API_ERROR(?ERROR_INVALID_REQUEST_CODE, ?ERROR_INVALID_REQUEST_DESCR).