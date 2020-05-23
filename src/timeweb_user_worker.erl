%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. май 2020 20:13
%%%-------------------------------------------------------------------
-module(timeweb_user_worker).
-author("GRECHNEVAV").

-behaviour(gen_server).

%% API
-export([start_link/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2,
  code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {
  user = #{} :: map(),
  token = <<>> :: binary()
}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Args) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, Args, []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init({User, Token}) ->
  {ok, #state{user = User, token = Token}}.

handle_call({is_valid_token, Token}, _From, #state{token = Token} = State)  ->
  {reply, true, State};
handle_call({is_valid_token, _}, _From, State)  ->
  {reply, false, State};
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
