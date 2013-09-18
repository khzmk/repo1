%-*-Mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:
%%%
%%%------------------------------------------------------------------------
%%% @doc
%%% ==CloudI Database==
%%% Provide a simple in-memory database.
%%% @end
%%%
%%% BSD LICENSE
%%% 
%%% Copyright (c) 2013, Michael Truog <mjtruog at gmail dot com>
%%% All rights reserved.
%%% 
%%% Redistribution and use in source and binary forms, with or without
%%% modification, are permitted provided that the following conditions are met:
%%% 
%%%     * Redistributions of source code must retain the above copyright
%%%       notice, this list of conditions and the following disclaimer.
%%%     * Redistributions in binary form must reproduce the above copyright
%%%       notice, this list of conditions and the following disclaimer in
%%%       the documentation and/or other materials provided with the
%%%       distribution.
%%%     * All advertising materials mentioning features or use of this
%%%       software must display the following acknowledgment:
%%%         This product includes software developed by Michael Truog
%%%     * The name of the author may not be used to endorse or promote
%%%       products derived from this software without specific prior
%%%       written permission
%%% 
%%% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
%%% CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
%%% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
%%% OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
%%% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
%%% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
%%% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
%%% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
%%% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
%%% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
%%% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
%%% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
%%% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
%%% DAMAGE.
%%%
%%% @author Michael Truog <mjtruog [at] gmail (dot) com>
%%% @copyright 2013 Michael Truog
%%% @version 1.3.0 {@date} {@time}
%%%------------------------------------------------------------------------

-module(cloudi_service_db).
-author('mjtruog [at] gmail (dot) com').

-behaviour(cloudi_service).

%% external interface
-export([kv_new/5,
         kv_delete/4,
         kv_delete/5,
         kv_get/4,
         kv_get/5,
         kv_put/6]).

%% cloudi_service callbacks
-export([cloudi_service_init/3,
         cloudi_service_handle_request/11,
         cloudi_service_handle_info/3,
         cloudi_service_terminate/2]).

-include_lib("cloudi_core/include/cloudi_logger.hrl").

-define(DEFAULT_TABLE_MODULE,             dict). % dict API
-define(DEFAULT_OUTPUT,               internal).
-define(DEFAULT_ENDIAN,                 native). % when output == external
-define(DEFAULT_USE_KEY_VALUE,            true). % functionality

-record(state,
    {
        tables = cloudi_x_trie:new() :: cloudi_x_trie:trie(),
        prefix_length :: integer(),
        uuid_generator :: cloudi_x_uuid:state(),
        table_module :: atom(),
        output_type :: internal | external,
        endian :: big | little | native,
        use_key_value :: boolean()
    }).

%%%------------------------------------------------------------------------
%%% External interface functions
%%%------------------------------------------------------------------------

%%-------------------------------------------------------------------------
%% @doc
%% ===Store a new value in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_new(Dispatcher :: cloudi_service:dispatcher(),
             Name :: cloudi_service:service_name(),
             Table :: string() | binary(),
             Value :: any(),
             Timeout :: cloudi_service:timeout_milliseconds()) ->
    {ok, Key :: binary(), NewValue :: any()} |
    {error, any()}.

kv_new(Dispatcher, Name, Table, Value, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {new, Table, Value}, Timeout) of
        {ok, {ok, _, _} = Success} ->
            Success;
        {error, _} = Error ->
            Error
    end.

%%-------------------------------------------------------------------------
%% @doc
%% ===Delete all table values in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_delete(Dispatcher :: cloudi_service:dispatcher(),
                Name :: cloudi_service:service_name(),
                Table :: string() | binary(),
                Timeout :: cloudi_service:timeout_milliseconds()) ->
    ok |
    {error, any()}.

kv_delete(Dispatcher, Name, Table, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {delete, Table}, Timeout) of
        {ok, ok} ->
            ok;
        {error, _} = Error ->
            Error
    end.

%%-------------------------------------------------------------------------
%% @doc
%% ===Delete a value in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_delete(Dispatcher :: cloudi_service:dispatcher(),
                Name :: cloudi_service:service_name(),
                Table :: string() | binary(),
                Key :: binary(),
                Timeout :: cloudi_service:timeout_milliseconds()) ->
    ok |
    {error, any()}.

kv_delete(Dispatcher, Name, Table, Key, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {delete, Table, Key}, Timeout) of
        {ok, ok} ->
            ok;
        {error, _} = Error ->
            Error
    end.

%%-------------------------------------------------------------------------
%% @doc
%% ===Retrieve all table values in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_get(Dispatcher :: cloudi_service:dispatcher(),
             Name :: cloudi_service:service_name(),
             Table :: string() | binary(),
             Timeout :: cloudi_service:timeout_milliseconds()) ->
    {ok, list({Key :: binary(), Value :: any()})} |
    {error, any()}.

kv_get(Dispatcher, Name, Table, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {get, Table}, Timeout) of
        {ok, {ok, _} = Success} ->
            Success;
        {error, _} = Error ->
            Error
    end.

%%-------------------------------------------------------------------------
%% @doc
%% ===Retrieve a table value in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_get(Dispatcher :: cloudi_service:dispatcher(),
             Name :: cloudi_service:service_name(),
             Table :: string() | binary(),
             Key :: binary(),
             Timeout :: cloudi_service:timeout_milliseconds()) ->
    {ok, Key :: binary(), Value :: any()} |
    {error, any()}.

kv_get(Dispatcher, Name, Table, Key, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {get, Table, Key}, Timeout) of
        {ok, {ok, Value}} ->
            {ok, Key, Value};
        {error, _} = Error ->
            Error
    end.

%%-------------------------------------------------------------------------
%% @doc
%% ===Store a table value in the key-value db.===
%% @end
%%-------------------------------------------------------------------------

-spec kv_put(Dispatcher :: cloudi_service:dispatcher(),
             Name :: cloudi_service:service_name(),
             Table :: string() | binary(),
             Key :: binary(),
             Value :: any(),
             Timeout :: cloudi_service:timeout_milliseconds()) ->
    {ok, Key :: binary(), Value :: any()} |
    {error, any()}.

kv_put(Dispatcher, Name, Table, Key, Value, Timeout) ->
    case cloudi_service:send_sync(Dispatcher, Name,
                                  {put, Table, Key, Value}, Timeout) of
        {ok, {ok, NewValue}} ->
            {ok, Key, NewValue};
        {error, _} = Error ->
            Error
    end.

%%%------------------------------------------------------------------------
%%% Callback functions from cloudi_service
%%%------------------------------------------------------------------------

cloudi_service_init(Args, Prefix, Dispatcher) ->
    Defaults = [
        {table_module,             ?DEFAULT_TABLE_MODULE},
        {output,                   ?DEFAULT_OUTPUT},
        {endian,                   ?DEFAULT_ENDIAN},
        {use_key_value,            ?DEFAULT_USE_KEY_VALUE}],
    [TableModule, OutputType, Endian, UseKeyValue] =
        cloudi_proplists:take_values(Defaults, Args),
    true = is_atom(TableModule),
    {file, _} = code:is_loaded(TableModule),
    true = OutputType =:= internal orelse OutputType =:= external,
    true = (Endian =:= big orelse
            Endian =:= little orelse
            Endian =:= native),
    true = is_boolean(UseKeyValue),
    cloudi_service:subscribe(Dispatcher, "*"), % dynamic database name
    Self = cloudi_service:self(Dispatcher),
    {ok, #state{prefix_length = erlang:length(Prefix),
                uuid_generator = cloudi_x_uuid:new(Self),
                table_module = TableModule,
                output_type = OutputType,
                endian = Endian,
                use_key_value = UseKeyValue}}.

cloudi_service_handle_request(_Type, Name, _Pattern, _RequestInfo, Request,
                              _Timeout, _Priority, _TransId, _Pid,
                              #state{prefix_length = PrefixLength} = State,
                              _Dispatcher) ->
    do_query(lists:nthtail(PrefixLength, Name), Request, State).

cloudi_service_handle_info(Request, State, _) ->
    ?LOG_WARN("Unknown info \"~p\"", [Request]),
    {noreply, State}.

cloudi_service_terminate(_, #state{}) ->
    ok.

%%%------------------------------------------------------------------------
%%% Private functions
%%%------------------------------------------------------------------------

do_query(Database, Request,
         #state{use_key_value = true} = State) ->
    key_value(cloudi_request:new(Request, internal),
              Database, Request, State).
    
key_value({Command, Table},
          Database, Request, State)
    when is_binary(Table) ->
    key_value({Command, erlang:binary_to_list(Table)},
              Database, Request, State);
key_value({Command, Table, Arg1},
          Database, Request, State)
    when is_binary(Table) ->
    key_value({Command, erlang:binary_to_list(Table), Arg1},
              Database, Request, State);
key_value({Command, Table, Arg1, Arg2},
          Database, Request, State)
    when is_binary(Table) ->
    key_value({Command, erlang:binary_to_list(Table), Arg1, Arg2},
              Database, Request, State);
key_value({new, [I | _] = Table, Value},
          Database, Request,
          #state{tables = Tables,
                 uuid_generator = UUID,
                 table_module = TableModule} = State)
    when is_integer(I) ->
    Key = cloudi_x_uuid:get_v1(UUID),
    TableName = Database ++ [$* | Table],
    NewValue = case Value of
        <<0:128, Rest/binary>> ->
            <<Key:128/binary, Rest/binary>>;
        [undefined | L] ->
            [Key | L];
        _ when is_tuple(Value), is_atom(element(1, Value)) ->
            case element(1, Value) of
                undefined ->
                    erlang:setelement(1, Value, Key);
                _ ->
                    case element(2, Value) of
                        undefined ->
                            erlang:setelement(2, Value, Key);
                        _ ->
                            Value
                    end
            end;
        _ ->
            Value
    end,
    NewTables = cloudi_x_trie:update(TableName, fun(Old) ->
            TableModule:store(Key, NewValue, Old)
        end, TableModule:store(Key, NewValue, TableModule:new()), Tables),
    {reply,
     response(Request, {ok, Key, NewValue}, State),
     State#state{tables = NewTables}};
key_value({delete, [I | _] = Table},
          Database, Request,
          #state{tables = Tables} = State)
    when is_integer(I) ->
    TableName = Database ++ [$* | Table],
    NewTables = cloudi_x_trie:erase(TableName, Tables),
    {reply,
     response(Request, ok, State),
     State#state{tables = NewTables}};
key_value({delete, [I | _] = Table, Key},
          Database, Request,
          #state{tables = Tables,
                 table_module = TableModule} = State)
    when is_integer(I) ->
    TableName = Database ++ [$* | Table],
    NewTables = cloudi_x_trie:update(TableName, fun(Old) ->
            TableModule:erase(Key, Old)
        end, TableModule:new(), Tables),
    {reply,
     response(Request, ok, State),
     State#state{tables = NewTables}};
key_value({get, [I | _] = Table},
          Database, Request,
          #state{tables = Tables,
                 table_module = TableModule} = State)
    when is_integer(I) ->
    TableName = Database ++ [$* | Table],
    case cloudi_x_trie:find(TableName, Tables) of
        {ok, TableValues} ->
            {reply,
             response(Request, {ok, TableModule:to_list(TableValues)}, State),
             State};
        error ->
            {reply,
             response(Request, {ok, []}, State),
             State}
    end;
key_value({get, [I | _] = Table, Key},
          Database, Request,
          #state{tables = Tables,
                 table_module = TableModule} = State)
    when is_integer(I) ->
    TableName = Database ++ [$* | Table],
    Response = case cloudi_x_trie:find(TableName, Tables) of
        {ok, TableValues} ->
            case TableModule:find(Key, TableValues) of
                {ok, Value} ->
                    response(Request, {ok, Value}, State);
                error ->
                    response(Request, {ok, undefined}, State)
            end;
        error ->
            response(Request, {ok, undefined}, State)
    end,
    {reply, Response, State};
key_value({put, [I | _] = Table, Key, Value},
          Database, Request,
          #state{tables = Tables,
                 table_module = TableModule} = State)
    when is_integer(I) ->
    TableName = Database ++ [$* | Table],
    NewTables = cloudi_x_trie:update(TableName, fun(Old) ->
            TableModule:store(Key, Value, Old)
        end, TableModule:store(Key, Value, TableModule:new()), Tables),
    {reply,
     response(Request, {ok, Value}, State),
     State#state{tables = NewTables}};
key_value(Command,
          _Database, Request, State) ->
    {reply,
     response(Request, {error, {invalid_command, Command}}, State),
     State}.

-compile({inline, [{response, 3}]}).
response(Request, Response,
         #state{output_type = internal}) ->
    cloudi_response:new_internal(Request, Response);
response(Request, Response,
         #state{output_type = external,
                endian = Endian}) ->
    cloudi_response:new_external(Request, Response, Endian).
