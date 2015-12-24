module LogService where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Http
import Json.Decode as Json
import Task
import StartApp


-- MODEL

type alias Model =
    { logs : String
    , serviceUrl : String
    }


init : (Model, Effects Action)
init =
  ( Model "" "http://localhost:4000/show"
  , Effects.none
  )


-- UPDATE

type Action
    = Refresh 
    | RefreshData (Maybe String)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Refresh ->
        ( model, getLogs model.serviceUrl)
    RefreshData data ->
        ( Model (Maybe.withDefault "none" data) model.serviceUrl
        , Effects.none
        )      


--update : Action -> Model -> (Model, Effects Action)
--update action model =
--  case action of
--    RequestMore ->
--      (model, getRandomGif model.topic)

--    NewGif maybeUrl ->
--      ( Model model.topic (Maybe.withDefault model.gifUrl maybeUrl)
--      , Effects.none
--      )      


-- VIEW

--(=>) = (,)


--view : Signal.Address Action -> Model -> Html
--view address model =
--  div [ style [ "width" => "200px" ] ]
--    [ h2 [headerStyle] [text model.topic]
--    , div [imgStyle model.gifUrl] []
--    , button [ onClick address RequestMore ] [ text "More Please!" ]
--    ]


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
    div [] 
        [ textarea 
            [containerStyle] 
            [text (toString model.logs)]
        ]

containerStyle : Attribute
containerStyle =
  style
    [ ("width" , "100%")    
    ]


--imgStyle : String -> Attribute
--imgStyle url =
--  style
--    [ "display" => "inline-block"
--    , "width" => "200px"
--    , "height" => "200px"
--    , "background-position" => "center center"
--    , "background-size" => "cover"
--    , "background-image" => ("url('" ++ url ++ "')")
--    ]


-- EFFECTS

getLogs : String -> Effects Action
getLogs serviceUrl =
  Http.get decodeUrl serviceUrl    
    |> Task.toMaybe    
    |> Task.map RefreshData
    |> Effects.task


decodeUrl : Json.Decoder String
decodeUrl =
  Json.at ["log"] Json.string


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

