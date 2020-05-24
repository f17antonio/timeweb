%%%-------------------------------------------------------------------
%%% @author GRECHNEVAV
%%% @copyright (C) 2020, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. май 2020 22:37
%%%-------------------------------------------------------------------
-module(timeweb_utils).
-author("GRECHNEVAV").

%% API

-export([get_token/0, json_decode/1]).

json_decode(Json) ->
  try
      jsone:decode(Json)
  catch
      _:_  -> #{}
  end .

get_token() ->
  Uuid = uuid_v4(),
  list_to_binary(lists:flatten(io_lib:format(
    "~8.16.0b-~4.16.0b-~4.16.0b-~2.16.0b~2.16.0b-~12.16.0b",
    uuid_get_parts(Uuid))
  )).

uuid_v4() ->
  uuid_v4(
    rand:uniform(round(math:pow(2, 48))) - 1,
    rand:uniform(round(math:pow(2, 12))) - 1,
    rand:uniform(round(math:pow(2, 32))) - 1,
    rand:uniform(round(math:pow(2, 30))) - 1
  ).

uuid_v4(R1, R2, R3, R4) ->
  <<R1:48, 4:4, R2:12, 2:2, R3:32, R4: 30>>.

uuid_get_parts(<<TL:32, TM:16, THV:16, CSR:8, CSL:8, N:48>>) ->
  [TL, TM, THV, CSR, CSL, N].