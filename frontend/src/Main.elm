module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Task exposing (Task)
import Navigation
import Route exposing (Route, href, fromLocation)
import Pages.Utils exposing (PageLoadError)
import Pages.Landing as LandingPage
import Pages.Posts as PostsPage
import Pages.NotFound


type Page
    = NotFound
    | Landing
    | Posts PostsPage.Model


type alias Model =
    { page : Page }


initalModel : Model
initalModel =
    { page = Landing }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    routeChange
        (fromLocation location)
        initalModel


view : Model -> Html Msg
view model =
    case model.page of
        Landing ->
            LandingPage.view

        Posts subModel ->
            PostsPage.view subModel

        _ ->
            Pages.NotFound.view


routeChange : Maybe Route -> Model -> ( Model, Cmd Msg )
routeChange maybeRoute model =
    let
        transitionToRoute page toMsg ( initPage, initTask ) =
            ( { model | page = page initPage }
            , Task.attempt toMsg initTask
            )
    in
        case maybeRoute of
            Just Route.Landing ->
                ( { model | page = Landing }
                , Cmd.none
                )

            Just Route.Posts ->
                transitionToRoute Posts PostsLoaded PostsPage.init

            _ ->
                ( { model | page = NotFound }
                , Cmd.none
                )


type Msg
    = RouteChange (Maybe Route)
    | PostsLoaded (Result PostsPage.Model PostsPage.Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( RouteChange maybeRoute, _ ) ->
            routeChange maybeRoute model

        ( PostsLoaded (Ok subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( PostsLoaded (Err subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program (fromLocation >> RouteChange)
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
