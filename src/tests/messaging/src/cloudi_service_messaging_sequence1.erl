%-*-Mode:erlang;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
% ex: set ft=erlang fenc=utf-8 sts=4 ts=4 sw=4 et:
%%%
%%%------------------------------------------------------------------------
%%% @doc
%%% ==CloudI Service for the messaging Test (sequence1)==
%%% @end
%%%
%%% BSD LICENSE
%%% 
%%% Copyright (c) 2012-2014, Michael Truog <mjtruog at gmail dot com>
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
%%% @copyright 2012-2014 Michael Truog
%%% @version 1.4.0 {@date} {@time}
%%%------------------------------------------------------------------------

-module(cloudi_service_messaging_sequence1).
-author('mjtruog [at] gmail (dot) com').
-vsn("1.4.0").

-behaviour(cloudi_service).

%% cloudi_service callbacks
-export([cloudi_service_init/4,
         cloudi_service_handle_request/11,
         cloudi_service_handle_info/3,
         cloudi_service_terminate/3]).

-include_lib("cloudi_core/include/cloudi_logger.hrl").

-record(state, {
    }).

%%%------------------------------------------------------------------------
%%% External interface functions
%%%------------------------------------------------------------------------


%%%------------------------------------------------------------------------
%%% Callback functions from cloudi_service
%%%------------------------------------------------------------------------

cloudi_service_init(_Args, Prefix, _Timeout, Dispatcher) ->
    cloudi_service:subscribe(Dispatcher, "a/b/c/d"),
    cloudi_service:subscribe(Dispatcher, "a/b/c/*"),
    cloudi_service:subscribe(Dispatcher, "a/b/*/d"),
    cloudi_service:subscribe(Dispatcher, "a/*/c/d"),
    cloudi_service:subscribe(Dispatcher, "*/b/c/d"),
    cloudi_service:subscribe(Dispatcher, "a/b/*"),
    cloudi_service:subscribe(Dispatcher, "a/*/d"),
    cloudi_service:subscribe(Dispatcher, "*/c/d"),
    cloudi_service:subscribe(Dispatcher, "a/*"),
    cloudi_service:subscribe(Dispatcher, "*/d"),
    cloudi_service:subscribe(Dispatcher, "*"),
    cloudi_service:subscribe(Dispatcher, "sequence1"),
    case cloudi_service:process_index(Dispatcher) of
        0 ->
            ?LOG_TRACE("~p is sending", [?FUNCTION]),
            cloudi_service:send_async(Dispatcher,
                                      Prefix ++ "sequence1", "start");
        _ ->
            ok
    end,
    {ok, #state{}}.

cloudi_service_handle_request(_Type, _Name, Pattern, _RequestInfo, Request,
                              _Timeout, _Priority, _TransId, _Pid,
                              #state{} = State,
                              Dispatcher) ->
    Prefix = cloudi_service:prefix(Dispatcher),
    case Request of
        "start" ->
            consume_end_and_sleep(Dispatcher),
            {memory, Memory} = erlang:process_info(self(), memory),
            [$/ | PrefixSuffix0] = lists:reverse(Prefix),
            PrefixSuffix1 = lists:reverse(
                cloudi_string:beforel($/, PrefixSuffix0, empty)),
            ?LOG_INFO("messaging sequence1 start erlang"
                      " ~s (memory = ~p)", [PrefixSuffix1, Memory]),
            sequence1(Dispatcher, Prefix),
            ?LOG_INFO("messaging sequence1 end erlang", []),
            cloudi_service:send_async(Dispatcher,
                                      Prefix ++ "sequence2", "start"),
            {reply, "end", State#state{}};
        <<"test1">> ->
            true = Pattern == (Prefix ++ "a/b/c/d"),
            {reply, Request, State};
        <<"test2">> ->
            true = Pattern == (Prefix ++ "a/b/c/*"),
            {reply, Request, State};
        <<"test3">> ->
            true = Pattern == (Prefix ++ "a/b/c/*"),
            {reply, Request, State};
        <<"test4">> ->
            true = Pattern == (Prefix ++ "a/b/*/d"),
            {reply, Request, State};
        <<"test5">> ->
            true = Pattern == (Prefix ++ "a/b/*/d"),
            {reply, Request, State};
        <<"test6">> ->
            true = Pattern == (Prefix ++ "a/*/c/d"),
            {reply, Request, State};
        <<"test7">> ->
            true = Pattern == (Prefix ++ "a/*/c/d"),
            {reply, Request, State};
        <<"test8">> ->
            true = Pattern == (Prefix ++ "*/b/c/d"),
            {reply, Request, State};
        <<"test9">> ->
            true = Pattern == (Prefix ++ "*/b/c/d"),
            {reply, Request, State};
        <<"test10">> ->
            true = Pattern == (Prefix ++ "a/b/*"),
            {reply, Request, State};
        <<"test11">> ->
            true = Pattern == (Prefix ++ "a/*/d"),
            {reply, Request, State};
        <<"test12">> ->
            true = Pattern == (Prefix ++ "*/c/d"),
            {reply, Request, State};
        <<"test13">> ->
            true = Pattern == (Prefix ++ "a/*"),
            {reply, Request, State};
        <<"test14">> ->
            true = Pattern == (Prefix ++ "*/d"),
            {reply, Request, State};
        <<"test15">> ->
            true = Pattern == (Prefix ++ "*"),
            {reply, Request, State}
    end.

cloudi_service_handle_info(Request, State, _Dispatcher) ->
    ?LOG_WARN("Unknown info \"~p\"", [Request]),
    {noreply, State}.

cloudi_service_terminate(_Reason, _Timeout, #state{}) ->
    ?LOG_INFO("terminate messaging 1 erlang", []),
    ok.

%%%------------------------------------------------------------------------
%%% Private functions
%%%------------------------------------------------------------------------

sequence1(Dispatcher, Prefix) ->
    % n.b., depends on cloudi_constants.hrl having
    % GROUP_NAME_PATTERN_MATCHING defined
    {ok, Test1Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/b/c/d", <<"test1">>),
    {ok, Test2Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/b/c/z", <<"test2">>),
    {ok, Test3Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/b/c/dd", <<"test3">>),
    {ok, Test4Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/b/z/d", <<"test4">>),
    {ok, Test5Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/b/cc/d", <<"test5">>),
    {ok, Test6Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/z/c/d", <<"test6">>),
    {ok, Test7Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "a/bb/c/d", <<"test7">>),
    {ok, Test8Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "z/b/c/d", <<"test8">>),
    {ok, Test9Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                              "aa/b/c/d", <<"test9">>),
    {ok, Test10Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "a/b/czd", <<"test10">>),
    {ok, Test11Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "a/bzc/d", <<"test11">>),
    {ok, Test12Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "azb/c/d", <<"test12">>),
    {ok, Test13Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "a/bzczd", <<"test13">>),
    {ok, Test14Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "azbzc/d", <<"test14">>),
    {ok, Test15Id} = cloudi_service:send_async(Dispatcher, Prefix ++
                                               "azbzczd", <<"test15">>),
    % n.b., depends on cloudi_constants.hrl having
    % RECV_ASYNC_STRATEGY == recv_async_select_oldest
    cloudi_service:recv_async(Dispatcher, Test1Id, false),
    {ok, <<>>, Test1Response, Test1Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test1">> = Test1Response,
    cloudi_service:recv_async(Dispatcher, Test2Id, false),
    {ok, <<>>, Test2Response, Test2Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test2">> = Test2Response,
    cloudi_service:recv_async(Dispatcher, Test3Id, false),
    {ok, <<>>, Test3Response, Test3Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test3">> = Test3Response,
    cloudi_service:recv_async(Dispatcher, Test4Id, false),
    {ok, <<>>, Test4Response, Test4Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test4">> = Test4Response,
    cloudi_service:recv_async(Dispatcher, Test5Id, false),
    {ok, <<>>, Test5Response, Test5Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test5">> = Test5Response,
    cloudi_service:recv_async(Dispatcher, Test6Id, false),
    {ok, <<>>, Test6Response, Test6Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test6">> = Test6Response,
    cloudi_service:recv_async(Dispatcher, Test7Id, false),
    {ok, <<>>, Test7Response, Test7Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test7">> = Test7Response,
    cloudi_service:recv_async(Dispatcher, Test8Id, false),
    {ok, <<>>, Test8Response, Test8Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test8">> = Test8Response,
    cloudi_service:recv_async(Dispatcher, Test9Id, false),
    {ok, <<>>, Test9Response, Test9Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test9">> = Test9Response,
    cloudi_service:recv_async(Dispatcher, Test10Id, false),
    {ok, <<>>, Test10Response, Test10Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test10">> = Test10Response,
    cloudi_service:recv_async(Dispatcher, Test11Id, false),
    {ok, <<>>, Test11Response, Test11Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test11">> = Test11Response,
    cloudi_service:recv_async(Dispatcher, Test12Id, false),
    {ok, <<>>, Test12Response, Test12Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test12">> = Test12Response,
    cloudi_service:recv_async(Dispatcher, Test13Id, false),
    {ok, <<>>, Test13Response, Test13Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test13">> = Test13Response,
    cloudi_service:recv_async(Dispatcher, Test14Id, false),
    {ok, <<>>, Test14Response, Test14Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test14">> = Test14Response,
    cloudi_service:recv_async(Dispatcher, Test15Id, false),
    {ok, <<>>, Test15Response, Test15Id} =
        cloudi_service:recv_async(Dispatcher),
    <<"test15">> = Test15Response,
    ok.

consume_end_and_sleep(Dispatcher) ->
    case cloudi_service:recv_async(Dispatcher, 1000) of
        {ok, <<>>, "end", _} ->
            consume_end_and_sleep(Dispatcher);
        {error, timeout} ->
            ok
    end.

