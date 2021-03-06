%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(markdown_middleware_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.

start(_Type, _Args) ->
	Dispatch = cowboy1_router:compile([
		{'_', [
			{"/[...]", cowboy1_static, {priv_dir, markdown_middleware, ""}}
		]}
	]),
	{ok, _} = cowboy1:start_http(http, 100, [{port, 8080}], [
		{env, [{dispatch, Dispatch}]},
		{middlewares, [cowboy1_router, markdown_converter, cowboy1_handler]}
	]),
	markdown_middleware_sup:start_link().

stop(_State) ->
	ok.
