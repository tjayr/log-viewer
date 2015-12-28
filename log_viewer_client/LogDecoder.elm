module LogDecoder where

import Json.Decode exposing ((:=))
import LogModel exposing (..)


{-| This function decodse a JSON representation of al og message into a LogEvent record
-}
decodeEvent : Json.Decode.Decoder LogEvent
decodeEvent = Json.Decode.map LogEvent    
    ( "timestamp" := Json.Decode.int) `apply`    
    ( "message" := Json.Decode.string) `apply`
    ( "loggerName" := Json.Decode.string) `apply`   
    ( "level" := Json.Decode.string) `apply`    
    ( "callerClass" := Json.Decode.string) `apply`
    ( "thread" := Json.Decode.string) `apply`   
    ( "callerMethod" := Json.Decode.string) `apply`
    ( "callerLine" := Json.Decode.string) `apply`
    ( "callerfilename" := Json.Decode.string) `apply`     
    ( "arg0" := Json.Decode.string) `apply`   
    ( "arg1" := Json.Decode.string) `apply`   
    ( "arg2" := Json.Decode.string) `apply`   
    ( "arg3" := Json.Decode.string)


{-| This is a helper function that allows us to decode json objects with more than 8 properties
    by chaining teh decoding operations using currying/partial application
-}
apply : Json.Decode.Decoder (a -> b) -> Json.Decode.Decoder a -> Json.Decode.Decoder b
apply func value =
    Json.Decode.object2 (<|) func value