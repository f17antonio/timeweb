%%%-------------------------------------------------------------------
%% @doc timeweb top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(timeweb_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
  {ok, Pools} = application:get_env(timeweb, mysql_pools),
  PoolSpecs = lists:map(
    fun({Name, SizeArgs, WorkerArgs}) ->
      PoolArgs = [{name, {local, Name}}, {worker_module, timeweb_pool_worker}] ++ SizeArgs,
      poolboy:child_spec(Name, PoolArgs, WorkerArgs)
    end,
    Pools
  ),
  UserMgrSpec = #{
    id       => timeweb_users_mgr,
    start    => {timeweb_users_mgr, start_link, []},
    restart  => transient,
    shutdown => infinity,
    type     => worker,
    modules  => [timeweb_users_mgr]
  },
  UserSupSpec = #{
    id       => timeweb_users_sup,
    start    => {timeweb_users_sup, start_link, []},
    restart  => permanent,
    shutdown => 5000,
    type     => supervisor
  },
  {ok, {{one_for_one, 10, 10}, [UserMgrSpec, UserSupSpec] ++ PoolSpecs}}.

%% internal functions
