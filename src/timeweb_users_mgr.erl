%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(timeweb_users_mgr).

-behaviour(gen_server).

-include("timeweb.hrl").

-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
  users_sessions = [] :: [{list(), pid()}]
}).

%%%===================================================================
%%% Spawning and gen_server implementation
%%%===================================================================

start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

init([]) ->
  {ok, #state{}}.

handle_call({signin_user, #{login := Login} = User}, _From, #state{users_sessions = UsersSessions} = State) ->
  Token = timeweb_utils:get_token(),
  case supervisor:start_child(timeweb_users_sup, [{User, Token}]) of
    {ok, Pid} ->
      {reply, {ok, Token}, State#state{users_sessions = [{Login, Pid} | UsersSessions]}};
    E ->
      lager:error("Cannot Create User Sessoins for User: ~p, error: ~p~n", [User, E]),
      {reply, {error, ?ERROR_CANNOT_CREATE_USER_SESSION_CODE}, State}
  end;
handle_call({signout_user, #{login := Login}}, _From, #state{users_sessions = UsersSessions} = State) ->
  {reply, ok, State#state{users_sessions = lists:keydelete(Login, 1, UsersSessions)}};
handle_call({is_authorized, Login, Token}, _From, #state{users_sessions = UsersSessions} = State) ->
  case lists:keyfind(Login, 1, UsersSessions) of
    {Login, WorkerPid} ->
      IsValidToken = gen_server:call(WorkerPid, {is_valid_token, Token}),
      {reply, IsValidToken, State};
    _ ->
      {reply, false, State}
  end;
handle_call(_Request, _From, State = #state{}) ->
  {reply, ok, State}.
handle_cast(_Request, State = #state{}) ->
  {noreply, State}.

handle_info(_Info, State = #state{}) ->
  {noreply, State}.

terminate(_Reason, _State = #state{}) ->
  ok.

code_change(_OldVsn, State = #state{}, _Extra) ->
  {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
