module LogService where

import LogModel exposing (..)
import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Task
import StartApp
import Json.Decode exposing ((:=))
import LogDecoder
import Date


-- MODEL

{-| The init function creates an empty model representation for when the application loads up.
-}
init : (Model, Effects Action)
init =
  ( Model defaultListOfLogEvent "http://localhost:8080/logViewer"
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


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Refresh ->
        ( model, getLogs model.serviceUrl)
    RefreshData data ->    
        let
            refreshedEvents =  (Maybe.withDefault defaultListOfLogEvent data)
            newEvents = model.logs ++ refreshedEvents
        in
            ( Model newEvents model.serviceUrl
            , Effects.none
            )      

-- VIEWS

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ refreshButton address model 
    , logContainer model
    ]


refreshButton : Signal.Address Action -> Model -> Html
refreshButton address model =
    div []
        [ button 
            [ onClick address Refresh ] 
            [ text "Refresh" ]
        ]

logContainer : Model -> Html
logContainer model = 
    div [] (eventListToString model)
      

containerStyle : Attribute
containerStyle =
  style
    [ ("width" , "80%")    
    ]


eventListToString: Model -> List Html
eventListToString model = 
    List.map (\e -> logDiv e) model.logs     


logDiv : LogEvent -> Html
logDiv event =
    div 
    [ style [("border-bottom", "1px solid black")]
    ]     
    [ text (toString <| Date.fromTime <| toFloat event.timestamp)
    , text ("Level " ++ event.level)
    , text ("Message: " ++ event.message)
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

