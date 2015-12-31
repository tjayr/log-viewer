module LogService where

import LogModel exposing (..)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (id, type', for, value, class, style)
import Html.Events exposing (..)
import Http
import Task
import StartApp
import Json.Decode exposing ((:=))
import LogDecoder
import Date
import Date.Format


-- MODEL

{-| The init function creates an empty model representation for when the application loads up.
-}
init : (Model, Effects Action)
init =
  ( Model defaultListOfLogEvent "http://localhost:<port>/logViewer"
  , Effects.none
  )

{-| This function creates an empty list of LogEvent for use by the init function.
    note the LogEvent takes 13 parameters - this is a record constructor. 
    Syntaicatly its very similar and for all intents and purposes does the same job as 
    a constructor in an OO language.
-}
defaultListOfLogEvent : List LogEvent
defaultListOfLogEvent = 
    [LogEvent 0 "" "" "" "" "" "" "" "" "" "" "" ""]
    

-- UPDATE

type Action
    = Refresh 
    | RefreshData (Maybe (List LogEvent))
    | UpdateUrl String


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Refresh ->
        ( model, getLogs model.serviceUrl)
    RefreshData data ->    
        let
            refreshedEvents =  (Maybe.withDefault defaultListOfLogEvent data)
            newEvents = refreshedEvents ++ model.logs               
        in
            ( Model newEvents model.serviceUrl
            , Effects.none
            )
    UpdateUrl newServiceUrl ->
        ( { model | 
                logs = model.logs
                , serviceUrl = newServiceUrl

            }            
        , Effects.none
        )
        

-- VIEWS

view : Signal.Address Action -> Model -> Html
view address model =
  div [globalStyle]
    [ refreshButton address model 
    , logContainer model
    ]


refreshButton : Signal.Address Action -> Model -> Html
refreshButton address model =
    div []
        [ button [ onClick address Refresh ] [ text "Refresh" ]
        , text "Service URL"         
        , input
            [ id "service-url"
            , type' "text"
            , value model.serviceUrl
            , on "input" targetValue (\str -> Signal.message address (UpdateUrl str))
            ]
            []

        ]

logContainer : Model -> Html
logContainer model = 
    div [] [logTable model.logs]
      


containerStyle : Attribute
containerStyle =
    style
    [ ("width" , "80%")    
    ]


globalStyle : Attribute
globalStyle = 
    style
    [ ("background", "#ffe")
    , ("font-size" , "11px")
    , ("font-family" , "Verdana, sans-serif")    
    ]    

plainStyle : Attribute
plainStyle =  
    style 
    [ ("background", "#ffe")
    ]

debugStyle : Attribute
debugStyle = 
    style 
    [ ("background", "#006600")
    , ("color", "#ffe")
    ]

errorStyle : Attribute
errorStyle = 
    style 
    [ ("background", "#B22222")
    , ("color", "#ffe")
    , ("font-weight", "500")
    ]

warningStyle : Attribute
warningStyle = 
    style 
    [ ("background", "#FF8C00")
    ]

selectStyle : LogEvent -> Attribute
selectStyle event =
    case event.level of
        "DEBUG" -> debugStyle
        "WARN" -> warningStyle
        "ERROR" -> errorStyle
        _ ->  plainStyle

eventListToString: Model -> List Html
eventListToString model = 
    List.map (\e -> logDiv e) model.logs     


logDiv : LogEvent -> Html
logDiv event =
    div 
    [ style [("border-bottom", "1px solid black")]
    ]     
    [ text (Date.Format.format "%Y-%m-%d %I:%M:%S" <| Date.fromTime <| toFloat event.timestamp)
    , text ("Level " ++ event.level)
    , text ("Message: " ++ event.message)
    ]


logTable : List LogEvent -> Html
logTable events =
    table [] ( [(logTableHeader)] ++ (List.map logTableRow events) )


logTableHeader : Html    
logTableHeader =
    tr [] 
    [ td [] [text "Timestamp"]
    , td [] [text "Level"]
    , td [] [text "Message"]
    , td [] [text "Thread"]
    , td [] [text "Filename"]
    , td [] [text "Class"]
    , td [] [text "Method"]
    , td [] [text "Line"]
    , td [] [text "Arg 0"]
    , td [] [text "Arg 1"]
    , td [] [text "Arg 2"]
    , td [] [text "Arg 3"]
    ]                 

    

logTableRow : LogEvent -> Html    
logTableRow event = 
    tr [ selectStyle event ] 
    [ td [] [ text (Date.Format.format "%Y-%m-%d %I:%M:%S" <| Date.fromTime <| toFloat event.timestamp)]
    , td [] [ text event.level ]
    , td [] [ text event.message ]
    , td [] [ text event.thread ]
    , td [] [ text event.callerfilename ]
    , td [] [ text event.callerClass ]
    , td [] [ text event.callerMethod ]
    , td [] [ text event.callerLine ]
    , td [] [ text event.arg0 ]
    , td [] [ text event.arg1 ]
    , td [] [ text event.arg2 ]
    , td [] [ text event.arg3 ]
    ]




-- EFFECTS

getLogs : String -> Effects Action
getLogs serviceUrl =
  Http.get (Json.Decode.list LogDecoder.decodeEvent) serviceUrl
    |> Task.toMaybe    
    |> Task.map RefreshData
    |> Effects.task



app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = []
    }


main =
  app.html


port tasks : Signal (Task.Task Never ())
port tasks =
  app.tasks

