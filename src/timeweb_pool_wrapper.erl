%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. май 2020 0:35
%%%-------------------------------------------------------------------
-module(timeweb_pool_wrapper).
-author("GRECHNEVAV").

%% API
-export([query/3, transaction/2, insert_id/1, affected_rows/1]).

query(PoolName, Stmt, Params) ->
  poolboy:transaction(PoolName, fun(Worker) ->
                                  gen_server:call(Worker, {query, Stmt, Params})
                                end).

transaction(PoolName, Fun) ->
  poolboy:transaction(PoolName, fun(Worker) ->
                                  gen_server:call(Worker, {transaction, Fun})
                                end).

insert_id(PoolName) ->
  poolboy:transaction(PoolName, fun(Worker) ->
                                   gen_server:call(Worker, insert_id)
                                end).

affected_rows(PoolName) ->
  poolboy:transaction(PoolName, fun(Worker) ->
                                  gen_server:call(Worker, affected_rows)
                                end).