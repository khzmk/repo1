#-*-Mode:elixir;coding:utf-8;tab-width:2;c-basic-offset:2;indent-tabs-mode:()-*-
# ex: set ft=elixir fenc=utf-8 sts=2 ts=2 sw=2 et nomod:
###
###------------------------------------------------------------------------
###
### MIT License
###
### Copyright (c) 2014-2017 Michael Truog <mjtruog at protonmail dot com>
###
### Permission is hereby granted, free of charge, to any person obtaining a
### copy of this software and associated documentation files (the "Software"),
### to deal in the Software without restriction, including without limitation
### the rights to use, copy, modify, merge, publish, distribute, sublicense,
### and/or sell copies of the Software, and to permit persons to whom the
### Software is furnished to do so, subject to the following conditions:
###
### The above copyright notice and this permission notice shall be included in
### all copies or substantial portions of the Software.
###
### THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
### IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
### FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
### AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
### LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
### FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
### DEALINGS IN THE SOFTWARE.
###
###------------------------------------------------------------------------

# logging levels explained:
#
#   fatal: indicates the system has failed and can not continue
#   error: indicates a subsystem has failed but the failure is not fatal
#   warn:  indicates an unexpected occurance was found in a subsystem
#   info:  indicates a subsystem has changed state
#   debug: reports subsystem data that should be useful for debugging
#   trace: reports subsystem data that is only for tracing execution

defmodule CloudILogger do

# Convenience macros

  defmacro function_name() do
    quote do
      case __ENV__.function do
        nil -> :undefined;
        {function, _} -> function
      end
    end
  end

  defmacro function_arity() do
    quote do
      case __ENV__.function do
        nil -> :undefined;
        {_, arity} -> arity
      end
    end
  end

# Typical logging output which will log asynchronously until the logger's
# message queue becomes too large, switching to synchronous logging
# while the message queue remains large

  defmacro log_fatal(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.fatal(__MODULE__,
                                            __ENV__.line,
                                            function,
                                            arity,
                                            unquote(format),
                                            unquote(args))
    end
  end

  defmacro log_error(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.error(__MODULE__,
                                            __ENV__.line,
                                            function,
                                            arity,
                                            unquote(format),
                                            unquote(args))
    end
  end

  defmacro log_warn(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.warn(__MODULE__,
                                           __ENV__.line,
                                           function,
                                           arity,
                                           unquote(format),
                                           unquote(args))
    end
  end

  defmacro log_info(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.info(__MODULE__,
                                           __ENV__.line,
                                           function,
                                           arity,
                                           unquote(format),
                                           unquote(args))
    end
  end

  defmacro log_debug(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.debug(__MODULE__,
                                            __ENV__.line,
                                            function,
                                            arity,
                                            unquote(format),
                                            unquote(args))
    end
  end

  defmacro log_trace(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.trace(__MODULE__,
                                            __ENV__.line,
                                            function,
                                            arity,
                                            unquote(format),
                                            unquote(args))
    end
  end

# Force the logging to be done synchronously to the local log only
# (if you are concerned about losing a logging message when the logging
#  is done asynchronously while the logger's message queue is somewhat large,
#  or if you want to make sure the logger's message queue is flushed,
#  during a rapid shutdown or crash, use these macros where necessary...
#  they are already used for service restart/stop events with the info
#  logging level, so it is unlikely it would be necessary to use the macros in
#  custom source code, if the info logging level is enabled)

  defmacro log_fatal_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.fatal_sync(__MODULE__,
                                                 __ENV__.line,
                                                 function,
                                                 arity,
                                                 unquote(format),
                                                 unquote(args))
    end
  end

  defmacro log_error_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.error_sync(__MODULE__,
                                                 __ENV__.line,
                                                 function,
                                                 arity,
                                                 unquote(format),
                                                 unquote(args))
    end
  end

  defmacro log_warn_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.warn_sync(__MODULE__,
                                                __ENV__.line,
                                                function,
                                                arity,
                                                unquote(format),
                                                unquote(args))
    end
  end

  defmacro log_info_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.info_sync(__MODULE__,
                                                __ENV__.line,
                                                function,
                                                arity,
                                                unquote(format),
                                                unquote(args))
    end
  end

  defmacro log_debug_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.debug_sync(__MODULE__,
                                                 __ENV__.line,
                                                 function,
                                                 arity,
                                                 unquote(format),
                                                 unquote(args))
    end
  end

  defmacro log_trace_sync(format, args) do
    quote do
      {function, arity} = case __ENV__.function do
        nil ->
            {:undefined, :undefined};
        {_, _} = function_arity ->
            function_arity
      end
      :cloudi_core_i_logger_interface.trace_sync(__MODULE__,
                                                 __ENV__.line,
                                                 function,
                                                 arity,
                                                 unquote(format),
                                                 unquote(args))
    end
  end

# Apply an anonymous function if allowed by the current logging level setting

  defmacro log_fatal_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.fatal_apply(unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_error_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.error_apply(unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_warn_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.warn_apply(unquote(f),
                                                 unquote(a))
    end
  end

  defmacro log_info_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.info_apply(unquote(f),
                                                 unquote(a))
    end
  end

  defmacro log_debug_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.debug_apply(unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_trace_apply(f, a) do
    quote do
      :cloudi_core_i_logger_interface.trace_apply(unquote(f),
                                                  unquote(a))
    end
  end

# Apply a module function if allowed by the current logging level setting

  defmacro log_fatal_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.fatal_apply(unquote(m),
                                                  unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_error_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.error_apply(unquote(m),
                                                  unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_warn_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.warn_apply(unquote(m),
                                                 unquote(f),
                                                 unquote(a))
    end
  end

  defmacro log_info_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.info_apply(unquote(m),
                                                 unquote(f),
                                                 unquote(a))
    end
  end

  defmacro log_debug_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.debug_apply(unquote(m),
                                                  unquote(f),
                                                  unquote(a))
    end
  end

  defmacro log_trace_apply(m, f, a) do
    quote do
      :cloudi_core_i_logger_interface.trace_apply(unquote(m),
                                                  unquote(f),
                                                  unquote(a))
    end
  end

# Get/Set lager-compatible logging metadata

  defmacro log_metadata_get() do
    quote do
      :cloudi_core_i_logger.metadata_get()
    end
  end

  defmacro log_metadata_set(l) do
    quote do
      :cloudi_core_i_logger.metadata_set(unquote(l))
    end
  end

end
