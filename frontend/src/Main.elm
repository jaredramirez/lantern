module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Navigation
import Route exposing (Route, href, fromLocation)
import Pages.Landing
import Pages.NotFound


type alias Model =
    { location : Route
    , title : String
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model
        (case fromLocation location of
            Nothing ->
                Route.NotFound

            Just route ->
                route
        )
        "title"
    , Cmd.none
    )


view : Model -> Html Msg
view model =
    case model.location of
        Route.Landing ->
            Pages.Landing.view model.title

        _ ->
            Pages.NotFound.view


type Msg
    = RouteChange (Maybe Route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChange (Just route) ->
            ( { model | location = route }
            , Cmd.none
            )

        RouteChange Nothing ->
            ( { model | location = Route.NotFound }
            , Cmd.none
            )


main : Program Never Model Msg
main =
    Navigation.program (fromLocation >> RouteChange)
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
