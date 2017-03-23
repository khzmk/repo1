{--*-Mode:haskell;coding:utf-8;tab-width:4;c-basic-offset:4;indent-tabs-mode:()-*-
  ex: set ft=haskell fenc=utf-8 sts=4 ts=4 sw=4 et nomod: -}

{-

  BSD LICENSE

  Copyright (c) 2017, Michael Truog <mjtruog at gmail dot com>
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above copyright
        notice, this list of conditions and the following disclaimer in
        the documentation and/or other materials provided with the
        distribution.
      * All advertising materials mentioning features or use of this
        software must display the following acknowledgment:
          This product includes software developed by Michael Truog
      * The name of the author may not be used to endorse or promote
        products derived from this software without specific prior
        written permission

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
  CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
  DAMAGE.

 -}

module Main where

import System.Exit (ExitCode(ExitFailure),exitWith)
import qualified Control.Concurrent as Concurrent
import qualified Data.Binary.Builder as Builder
import qualified Data.Binary.Get as Get
import qualified Data.ByteString as ByteString
import qualified Data.ByteString.Char8 as Char8
import qualified Data.ByteString.Lazy as LazyByteString
import qualified Data.Monoid as Monoid
import qualified Foreign.CloudI as CloudI
import qualified System.IO as SysIO
type ByteString = ByteString.ByteString
type RequestType = CloudI.RequestType
type Source = CloudI.Source

destination_ :: String
destination_ = "/tests/msg_size/erlang"

request_ :: RequestType -> ByteString -> ByteString ->
    ByteString -> ByteString -> Int -> Int -> ByteString -> Source ->
    () -> CloudI.T () -> IO (CloudI.Response ())
request_ type_ _ _ requestInfo request timeout priority transId pid state api =
    let destination = Char8.pack destination_
        decode = do
            i <- Get.getWord32host
            remaining <- Get.getRemainingLazyByteString
            return (fromIntegral i :: Int, remaining)
        (i0, extra) = Get.runGet decode $ LazyByteString.fromStrict request
        i1 = if i0 == 4294967295 then 0 else i0 + 1
        requestNew = LazyByteString.toStrict $ Builder.toLazyByteString $
            (Builder.putWord32host $ fromIntegral i1) `Monoid.mappend`
            (Builder.fromLazyByteString extra)
    in do
    putStrLn $ "forward #" ++ (show i1) ++ " haskell to " ++ destination_ ++
        " (with timeout " ++ (show timeout) ++ " ms)"
    CloudI.forward_ api
        type_ destination requestInfo requestNew timeout priority transId pid
    return $ CloudI.Null (state, api)

task :: Int -> IO ()
task threadIndex = do
    let prerr = SysIO.hPutStrLn SysIO.stderr
        prout = putStrLn
    apiValue <- CloudI.api threadIndex ()
    case apiValue of
        Left err ->
            prerr err
        Right api0 -> do
            let suffix = Char8.pack "haskell"
            subscribeValue <- CloudI.subscribe api0 suffix request_
            case subscribeValue of
                Left err ->
                    prerr err
                Right api1 -> do
                    pollValue <- CloudI.poll api1 (-1)
                    case pollValue of
                        Left err ->
                            prerr err
                        Right (_, _) ->
                            prout "terminate msg_size haskell"

main :: IO ()
main = do
    threadCountValue <- CloudI.threadCount
    case threadCountValue of
        Left err -> do
            SysIO.hPutStrLn SysIO.stderr err
            _ <- exitWith (ExitFailure 1)
            return ()
        Right threadCount -> do
            Concurrent.setNumCapabilities threadCount
            mapM_ (CloudI.threadCreate task) [0..threadCount - 1]
            CloudI.threadsWait

