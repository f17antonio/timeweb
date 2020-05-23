%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. май 2020 13:56
%%%-------------------------------------------------------------------
-module(timeweb_db).
-author("GRECHNEVAV").

-include("timeweb.hrl").

%% API
-export([register_user/3, get_user/2, change_password/3, get_all_users/0]).

register_user(Login, Password, UserName) ->
  QueryRes = timeweb_pool_wrapper:transaction(db_pool,
    fun() ->
      ok = timeweb_pool_wrapper:query(
        db_pool,
        "INSERT INTO users (login, password, name) VALUES (?, ?, ?)",
        [Login, Password, UserName]
      ),
      timeweb_pool_wrapper:insert_id(db_pool)
    end),
  case QueryRes of
    {atomic, UserId} ->
      {ok, UserId};
    Error ->
      lager:error("Db user registration Error: ~p~n", [Error]),
      {error, ?ERROR_CANNOT_REGISTER_CODE}
  end.

get_user(Login, Password) ->
  QueryRes = timeweb_pool_wrapper:query(
    db_pool,
    "SELECT user_id, login, name FROM users WHERE login = ? AND password = ?",
    [Login, Password]
  ),
  case QueryRes of
    {ok, _, [[UserId, Login, UserName]]} ->
      {ok, #{
        user_id   => UserId,
        login     => Login,
        user_name => UserName
      }};
    _ ->
      {error, ?ERROR_WRONG_LOGIN_PASSWORD_CODE}
  end.

change_password(Login, NewPassword, OldPassword) ->
  QueryRes = timeweb_pool_wrapper:transaction(db_pool,
    fun() ->
      ok = timeweb_pool_wrapper:query(
        db_pool,
        "UPDATE users SET password = ? WHERE login = ? AND password = ?",
        [NewPassword, Login, OldPassword]
      ),
      timeweb_pool_wrapper:affected_rows(db_pool)
    end),
  case QueryRes of
    {atomic, 1} -> ok;
    _           -> {error, ?ERROR_INVALID_OLD_PASSWORD_CODE}
  end.

get_all_users() ->
  QueryRes = timeweb_pool_wrapper:query(
    db_pool,
    "SELECT user_id, login, name FROM users",
    []
  ),
  case QueryRes of
    {ok, _, Users} ->
      {ok, #{users => [#{
        user_id   => UserId,
        login     => Login,
        user_name => UserName
      } || [UserId, Login, UserName] <- Users]}};
    _ ->
      {error, ?ERROR_INTERNAL_DB_ERROR_CODE}
  end.