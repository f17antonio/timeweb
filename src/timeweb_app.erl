%%%-------------------------------------------------------------------
%% @doc timeweb public API
%% @end
%%%-------------------------------------------------------------------

-module(timeweb_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    {ok, CowboySettings} = application:get_env(timeweb, cowboy),
    Port = proplists:get_value(port, CowboySettings, 8080),
    Dispatch = cowboy_router:compile([
        {'_', [
            {"/api/user/register",        timeweb_rest_handler, #{request_name => register}},
            {"/api/user/signin",          timeweb_rest_handler, #{request_name => signin}},
            {"/api/user/change_password", timeweb_rest_handler, #{request_name => change_password}},
            {"/api/users/list",           timeweb_rest_handler, #{request_name => users_list}}
        ]}
    ]),
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
        env => #{dispatch => Dispatch}
    }),
    timeweb_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
