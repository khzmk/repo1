package main

//-*-Mode:Go;coding:utf-8;tab-width:4;c-basic-offset:4-*-
// ex: set ft=go fenc=utf-8 sts=4 ts=4 sw=4 noet nomod:
//
// MIT License
//
// Copyright (c) 2017 Michael Truog <mjtruog at protonmail dot com>
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//

import (
	"cloudi"
	"fmt"
	"os"
	"sync"
	"unsafe"
)

const (
	destination = "/tests/msg_size/erlang"
	msg_size    = 2097152 // 2 MB
)

func request(requestType int, name, pattern string, requestInfo, request []byte, timeout uint32, priority int8, transId [16]byte, pid cloudi.Source, state interface{}, api *cloudi.Instance) ([]byte, []byte, error) {
	if len(request) != msg_size {
		panic(fmt.Errorf("len(requesst) != %d", msg_size))
	}
	iData := [4]byte{request[0], request[1], request[2], request[3]}
	i := (*uint32)(unsafe.Pointer(&iData))
	if *i == 4294967295 {
		*i = 0
	} else {
		*i += 1
	}
	os.Stdout.WriteString(fmt.Sprintf("forward #%d go to %s (with timeout %d ms)\n", *i, destination, timeout))
	copy(request[:4], iData[:])
	api.Forward(requestType, destination, requestInfo, request, timeout, priority, transId, pid)
	// execution doesn't reach here
	return nil, nil, nil
}

func task(threadIndex uint32, execution *sync.WaitGroup) {
	defer execution.Done()
	api, err := cloudi.API(threadIndex, nil)
	if err != nil {
		cloudi.ErrorWrite(os.Stderr, err)
		return
	}
	err = api.Subscribe("go", request)
	if err != nil {
		cloudi.ErrorWrite(os.Stderr, err)
		return
	}
	_, err = api.Poll(-1)
	if err != nil {
		cloudi.ErrorWrite(os.Stderr, err)
	}
	os.Stdout.WriteString("terminate msg_size go\n")
}

func main() {
	threadCount, err := cloudi.ThreadCount()
	if err != nil {
		cloudi.ErrorExit(os.Stderr, err)
	}
	var execution sync.WaitGroup
	for threadIndex := uint32(0); threadIndex < threadCount; threadIndex++ {
		execution.Add(1)
		go task(threadIndex, &execution)
	}
	execution.Wait()
}
