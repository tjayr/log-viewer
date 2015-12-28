module LogModel where

-- MODEL

{-| This is the applications model. It consists of 2 fields.
    The serviceUrl is the url of the log service application. 
    the logs property contains a list of LogEvents which is decribed later
-}
type alias Model =
    { logs : List LogEvent
    , serviceUrl : String
    }


{-| This is a LogEvent it is a simple representation of the log_event database table
    populated  by the Logback frameworks DB appender. It is a 'simple' representation becuase 
    it excludes any references to the the log_event_properties and log_event_exception tables 
    that logback uses.
-}
type alias LogEvent =
    { timestamp : Int
    , message : String
    , loggerName : String
    , level : String    
    , thread : String    
    , callerClass : String
    , callerMethod : String
    , callerLine : String
    , callerfilename : String    
    , arg0 : String
    , arg1 : String
    , arg2 : String
    , arg3 : String
    }
