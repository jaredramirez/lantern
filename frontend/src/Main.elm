module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Navigation
import Route exposing (Route, href, fromLocation)
import Pages.Landing
import Pages.Feed
import Pages.NotFound
import Data.Post exposing (Posts)
import Request.Post exposing (postsRequest, PostsResponse)
import GraphQL.Client.Http as GraphQLClient
import Task exposing (Task, onError)


sendPostsRequest : Cmd Msg
sendPostsRequest =
    GraphQLClient.sendQuery "http://localhost:3000/graphql" postsRequest
        |> Task.attempt RecievePosts


type alias Model =
    { location : Route
    , title : String
    , posts : Posts
    , postsError : String
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
        []
        ""
    , sendPostsRequest
    )


view : Model -> Html Msg
view model =
    case model.location of
        Route.Landing ->
            Pages.Landing.view model.title

        Route.Feed ->
            Pages.Feed.view

        _ ->
            Pages.NotFound.view


type Msg
    = RouteChange (Maybe Route)
    | RecievePosts PostsResponse


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

        RecievePosts (Ok posts) ->
            ( { model | posts = posts }
            , Cmd.none
            )

        RecievePosts (Err postsError) ->
            ( { model | postsError = "There was an error loading the posts." }, Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program (fromLocation >> RouteChange)
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
