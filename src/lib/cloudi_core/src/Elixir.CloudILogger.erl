-file("lib/cloudi_core/priv/CloudILogger.ex", 39).

-module('Elixir.CloudILogger').

-compile(no_auto_import).

-export(['MACRO-function_arity'/1,
	 'MACRO-function_name'/1, 'MACRO-log'/4,
	 'MACRO-log_apply'/4, 'MACRO-log_apply'/5,
	 'MACRO-log_debug'/3, 'MACRO-log_debug_apply'/3,
	 'MACRO-log_debug_apply'/4, 'MACRO-log_debug_sync'/3,
	 'MACRO-log_error'/3, 'MACRO-log_error_apply'/3,
	 'MACRO-log_error_apply'/4, 'MACRO-log_error_sync'/3,
	 'MACRO-log_fatal'/3, 'MACRO-log_fatal_apply'/3,
	 'MACRO-log_fatal_apply'/4, 'MACRO-log_fatal_sync'/3,
	 'MACRO-log_info'/3, 'MACRO-log_info_apply'/3,
	 'MACRO-log_info_apply'/4, 'MACRO-log_info_sync'/3,
	 'MACRO-log_metadata_get'/1, 'MACRO-log_metadata_set'/2,
	 'MACRO-log_sync'/4, 'MACRO-log_trace'/3,
	 'MACRO-log_trace_apply'/3, 'MACRO-log_trace_apply'/4,
	 'MACRO-log_trace_sync'/3, 'MACRO-log_warn'/3,
	 'MACRO-log_warn_apply'/3, 'MACRO-log_warn_apply'/4,
	 'MACRO-log_warn_sync'/3, '__info__'/1]).

-spec '__info__'(attributes | compile | functions |
		 macros | md5 | module | deprecated) -> any().

'__info__'(module) -> 'Elixir.CloudILogger';
'__info__'(functions) -> [];
'__info__'(macros) ->
    [{function_arity, 0}, {function_name, 0}, {log, 3},
     {log_apply, 3}, {log_apply, 4}, {log_debug, 2},
     {log_debug_apply, 2}, {log_debug_apply, 3},
     {log_debug_sync, 2}, {log_error, 2},
     {log_error_apply, 2}, {log_error_apply, 3},
     {log_error_sync, 2}, {log_fatal, 2},
     {log_fatal_apply, 2}, {log_fatal_apply, 3},
     {log_fatal_sync, 2}, {log_info, 2}, {log_info_apply, 2},
     {log_info_apply, 3}, {log_info_sync, 2},
     {log_metadata_get, 0}, {log_metadata_set, 1},
     {log_sync, 3}, {log_trace, 2}, {log_trace_apply, 2},
     {log_trace_apply, 3}, {log_trace_sync, 2},
     {log_warn, 2}, {log_warn_apply, 2}, {log_warn_apply, 3},
     {log_warn_sync, 2}];
'__info__'(attributes) ->
    erlang:get_module_info('Elixir.CloudILogger',
			   attributes);
'__info__'(compile) ->
    erlang:get_module_info('Elixir.CloudILogger', compile);
'__info__'(md5) ->
    erlang:get_module_info('Elixir.CloudILogger', md5);
'__info__'(deprecated) -> [].

'MACRO-function_arity'(_E@CALLER) ->
    {'case', [],
     [{{'.', [],
	[{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
       [], []},
      [{do,
	[{'->', [], [[nil], undefined]},
	 {'->', [],
	  [[{{'_', [], 'Elixir.CloudILogger'},
	     {arity, [], 'Elixir.CloudILogger'}}],
	   {arity, [], 'Elixir.CloudILogger'}]}]}]]}.

'MACRO-function_name'(_E@CALLER) ->
    {'case', [],
     [{{'.', [],
	[{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
       [], []},
      [{do,
	[{'->', [], [[nil], undefined]},
	 {'->', [],
	  [[{{function, [], 'Elixir.CloudILogger'},
	     {'_', [], 'Elixir.CloudILogger'}}],
	   {function, [], 'Elixir.CloudILogger'}]}]}]]}.

'MACRO-log'(_E@CALLER, EVlevel@1, EVformat@1,
	    EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, log]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVlevel@1,
	EVformat@1, EVargs@1]}]}.

'MACRO-log_apply'(_E@CALLER, EVlevel@1, EVf@1, EVa@1) ->
    {{'.', [], [cloudi_core_i_logger_interface, log_apply]},
     [], [EVlevel@1, EVf@1, EVa@1]}.

'MACRO-log_apply'(_E@CALLER, EVlevel@1, EVm@1, EVf@1,
		  EVa@1) ->
    {{'.', [], [cloudi_core_i_logger_interface, log_apply]},
     [], [EVlevel@1, EVm@1, EVf@1, EVa@1]}.

'MACRO-log_debug'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, debug]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_debug_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, debug_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_debug_apply'(_E@CALLER, EVm@1, EVf@1,
			EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, debug_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_debug_sync'(_E@CALLER, EVformat@1,
		       EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [],
	[cloudi_core_i_logger_interface, debug_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_error'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, error]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_error_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, error_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_error_apply'(_E@CALLER, EVm@1, EVf@1,
			EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, error_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_error_sync'(_E@CALLER, EVformat@1,
		       EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [],
	[cloudi_core_i_logger_interface, error_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_fatal'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, fatal]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_fatal_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, fatal_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_fatal_apply'(_E@CALLER, EVm@1, EVf@1,
			EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, fatal_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_fatal_sync'(_E@CALLER, EVformat@1,
		       EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [],
	[cloudi_core_i_logger_interface, fatal_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_info'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, info]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_info_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, info_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_info_apply'(_E@CALLER, EVm@1, EVf@1,
		       EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, info_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_info_sync'(_E@CALLER, EVformat@1,
		      EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, info_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_metadata_get'(_E@CALLER) ->
    {{'.', [], [cloudi_core_i_logger, metadata_get]}, [],
     []}.

'MACRO-log_metadata_set'(_E@CALLER, EVl@1) ->
    {{'.', [], [cloudi_core_i_logger, metadata_set]}, [],
     [EVl@1]}.

'MACRO-log_sync'(_E@CALLER, EVlevel@1, EVformat@1,
		 EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, log_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVlevel@1,
	EVformat@1, EVargs@1]}]}.

'MACRO-log_trace'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, trace]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_trace_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, trace_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_trace_apply'(_E@CALLER, EVm@1, EVf@1,
			EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, trace_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_trace_sync'(_E@CALLER, EVformat@1,
		       EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [],
	[cloudi_core_i_logger_interface, trace_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_warn'(_E@CALLER, EVformat@1, EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, warn]}, [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.

'MACRO-log_warn_apply'(_E@CALLER, EVf@1, EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, warn_apply]},
     [], [EVf@1, EVa@1]}.

'MACRO-log_warn_apply'(_E@CALLER, EVm@1, EVf@1,
		       EVa@1) ->
    {{'.', [],
      [cloudi_core_i_logger_interface, warn_apply]},
     [], [EVm@1, EVf@1, EVa@1]}.

'MACRO-log_warn_sync'(_E@CALLER, EVformat@1,
		      EVargs@1) ->
    {'__block__', [],
     [{'=', [],
       [{{function, [], 'Elixir.CloudILogger'},
	 {arity, [], 'Elixir.CloudILogger'}},
	{'case', [],
	 [{{'.', [],
	    [{'__ENV__', [], 'Elixir.CloudILogger'}, function]},
	   [], []},
	  [{do,
	    [{'->', [], [[nil], {undefined, undefined}]},
	     {'->', [],
	      [[{'=', [],
		 [{{'_', [], 'Elixir.CloudILogger'},
		   {'_', [], 'Elixir.CloudILogger'}},
		  {function_arity, [], 'Elixir.CloudILogger'}]}],
	       {function_arity, [], 'Elixir.CloudILogger'}]}]}]]}]},
      {{'.', [], [cloudi_core_i_logger_interface, warn_sync]},
       [],
       [{'__MODULE__', [], 'Elixir.CloudILogger'},
	{{'.', [],
	  [{'__ENV__', [], 'Elixir.CloudILogger'}, line]},
	 [], []},
	{function, [], 'Elixir.CloudILogger'},
	{arity, [], 'Elixir.CloudILogger'}, EVformat@1,
	EVargs@1]}]}.