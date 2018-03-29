#!/usr/bin/env python
#-*-Mode:python;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
# ex: set ft=python fenc=utf-8 sts=4 ts=4 sw=4 et nomod:
#
# MIT License
#
# Copyright (c) 2012-2017 Michael Truog <mjtruog at protonmail dot com>
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#

import sys, threading, struct, traceback
from cloudi_c import API, terminate_exception

_DESTINATION = '/tests/msg_size/erlang'

class _Task(threading.Thread):
    def __init__(self, thread_index):
        threading.Thread.__init__(self)
        self.__api = API(thread_index)

    def run(self):
        try:
            self.__api.subscribe('python_c', self.request)

            result = self.__api.poll()
            assert result == False
        except terminate_exception:
            pass
        except:
            traceback.print_exc(file=sys.stderr)
        print('terminate msg_size python_c')

    def request(self, request_type, name, pattern, request_info, request,
                timeout, priority, trans_id, pid):
        i = struct.unpack('=I', request[:4])[0]
        if i == 4294967295:
            i = 0
        else:
            i += 1
        request = struct.pack('=I', i) + request[4:]
        print('forward #%d python_c to %s (with timeout %d ms)' % (
            i, _DESTINATION, timeout,
        ))
        self.__api.forward_(request_type, _DESTINATION, request_info, request,
                            timeout, priority, trans_id, pid)

if __name__ == '__main__':
    thread_count = API.thread_count()
    assert thread_count >= 1
    
    threads = [_Task(i) for i in range(thread_count)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

