.PHONY: run

REBAR=./rebar3

start:
	@$(REBAR) escriptize
	@$(REBAR) release
	./_build/default/rel/timeweb/bin/timeweb daemon
stop:
	./_build/default/rel/timeweb/bin/timeweb stop