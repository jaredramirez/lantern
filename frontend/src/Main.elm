module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Task exposing (Task)
import Navigation
import Route exposing (Route, href, fromLocation)
import Pages.Utils exposing (PageLoadError)
import Pages.Landing as LandingPage
import Pages.Feed as FeedPage
import Pages.NotFound


type Page
    = NotFound
    | Landing
    | Feed FeedPage.Model


type alias Model =
    { page : Page }


initalPage : Page
initalPage =
    Landing


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    routeChange
        (fromLocation location)
        { page = Landing }


view : Model -> Html Msg
view model =
    case model.page of
        Landing ->
            LandingPage.view

        Feed subModel ->
            FeedPage.view subModel
                |> Html.map FeedMsg

        _ ->
            Pages.NotFound.view


routeChange : Maybe Route -> Model -> ( Model, Cmd Msg )
routeChange maybeRoute model =
    let
        transitionToRoute page toMsg ( newPage, task ) =
            ( { model | page = page newPage }
            , Task.attempt toMsg task
            )
    in
        case maybeRoute of
            Just Route.Landing ->
                ( { model | page = Landing }
                , Cmd.none
                )

            Just Route.Feed ->
                transitionToRoute Feed FeedLoaded FeedPage.init

            _ ->
                ( { model | page = NotFound }
                , Cmd.none
                )


type Msg
    = RouteChange (Maybe Route)
    | FeedLoaded (Result PageLoadError FeedPage.Model)
    | FeedMsg FeedPage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( RouteChange maybeRoute, _ ) ->
            routeChange maybeRoute model

        ( FeedLoaded (Ok subModel), _ ) ->
            ( { model | page = Feed subModel }, Cmd.none )

        -- ( FeedLoaded (Err subModel), _ ) ->
        -- ( { model | page = Feed subModel }, Cmd.none )
        ( FeedMsg subMsg, Feed subModel ) ->
            let
                ( newPage, newCmd ) =
                    FeedPage.update subMsg subModel
            in
                ( { model | page = Feed newPage }, Cmd.map FeedMsg newCmd )

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
