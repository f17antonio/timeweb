%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%% @end
%%%-------------------------------------------------------------------
-module(timeweb_users_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init(Args) ->
  AChild = #{id => timeweb_user_worker,
    start => {timeweb_user_worker, start_link, Args},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [timeweb_user_worker]},

  {ok, {#{strategy => simple_one_for_one,
    intensity => 1,
    period => 5},
    [AChild]}
  }.
