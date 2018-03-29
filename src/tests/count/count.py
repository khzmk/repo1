#!/usr/bin/env python
#-*-Mode:python;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
# ex: set ft=python fenc=utf-8 sts=4 ts=4 sw=4 et nomod:
#
# MIT License
#
# Copyright (c) 2017 Michael Truog <mjtruog at protonmail dot com>
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

import sys, threading, types, traceback
from cloudi import API, terminate_exception

class Task(threading.Thread):
    def __init__(self, api, name, exception):
        threading.Thread.__init__(self)
        self.__api = api
        self.__name = name
        self.__terminate_exception = exception
        self.__count = 0

    def run(self):
        try:
            self.__api.subscribe(self.__name + '/get', self.request)

            result = self.__api.poll()
            assert result == False
        except self.__terminate_exception:
            pass
        except:
            traceback.print_exc(file=sys.stderr)
        print('terminate count %s' % self.__name)

    def request(self, request_type, name, pattern, request_info, request,
                timeout, priority, trans_id, pid):
        if self.__count == 4294967295:
            self.__count = 0
        else:
            self.__count += 1
        print('count == %d %s' % (self.__count, self.__name))
        response = b'%d' % self.__count
        self.__api.return_(request_type, name, pattern,
                           b'', response,
                           timeout, trans_id, pid)

if __name__ == '__main__':
    thread_count = API.thread_count()
    assert thread_count >= 1
    
    threads = [Task(API(i), 'python', terminate_exception)
               for i in range(thread_count)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()

