-module(timeweb_ddl_runner).

-export([main/1]).

-define(CONFIG_PATH, "config/sys.config").
-define(DDL_DIR, "sql").
-define(CREATE_DB_DDL, "create_db.sql").
-define(CREATE_SCHEMA_DDL, "create_schema.sql").

-define(CREATE_DB_STRING(Su, SuPwd, Host, DbName), lists:concat([
  "mysql -u", Su, " -p", SuPwd, " -h ", Host, " -e \"set @dbname = '", DbName, "';source ",
  ?DDL_DIR, "/", ?CREATE_DB_DDL, ";\""
])).

-define(CREATE_SCHEMA_STRING(Su, SuPwd, Host, DbName), lists:concat([
    "mysql -u", Su, " -p", SuPwd, " -h ", Host, " ", DbName, " -e \"source ", ?DDL_DIR, "/", ?CREATE_SCHEMA_DDL, ";\""
  ])).

main(RawArgs) ->
  main(RawArgs, #{}).

main([], Args) when map_size(Args) == 0 ->
  LocalArgs = get_local_args(),
  run_ddl(LocalArgs),
  erlang:halt(0).

get_local_args() ->
  {ok, [Config]} = file:consult(?CONFIG_PATH),
  TimewebSettings = proplists:get_value(timeweb, Config),
  MysqlPoolsSettings = proplists:get_value(mysql_pools, TimewebSettings),
  [{db_pool, _,
    [{hostname, HostName}, {database, DbName}, {username, UserName}, {password, Password}]}] = MysqlPoolsSettings,
  #{su => UserName, supwd => Password, dbname => DbName, host => HostName}.

run_ddl(#{su := Su, supwd := SuPwd, dbname := DbName, host := Host}) ->
  CreateDbString = ?CREATE_DB_STRING(Su, SuPwd, Host, DbName),
  CreateSchemaString = ?CREATE_SCHEMA_STRING(Su, SuPwd, Host, DbName),
  CreateDbRes = os:cmd(CreateDbString),
  log_info("~n~ts", [CreateDbRes]),
  _CreateSchemaRes = os:cmd(CreateSchemaString);
  %log_info("CREATE SCHEMA RESULT:~n~ts", [CreateSchemaRes]);
run_ddl(Args) ->
  log_error("Wrong Args: ~tp", [Args]).

log(T, F, A) ->
  io:format("~ts:~ts~n", [T, io_lib:format(F,A)]).

-spec log_error(F::list(), A::list()) -> no_return().
log_error(F, A) ->
  log("ERROR", F, A).

log_info(F, A) ->
  log("INFO", F, A).
