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
import Pages.Post as PostPage
import Pages.NewPost as NewPostPage
import Pages.Login as LoginPage
import Pages.SignUp as SignUpPage
import Pages.NotFound as NotFoundPage


type Page
    = NotFound
    | Landing
    | Posts PostsPage.Model
    | Post PostPage.Model
    | NewPost NewPostPage.Model
    | Login
    | SignUp


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

        NewPost subModel ->
            NewPostPage.view subModel
                |> Html.map NewPostMsg

        Post subModel ->
            PostPage.view subModel
                |> Html.map PostMsg

        Login ->
            LoginPage.view

        SignUp ->
            SignUpPage.view

        _ ->
            NotFoundPage.view


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
                ( { model | page = Landing }, Cmd.none )

            Just Route.Posts ->
                transitionToRoute Posts PostsLoaded PostsPage.init

            Just Route.NewPost ->
                ( { model | page = NewPost NewPostPage.init }, Cmd.none )

            Just (Route.Post id) ->
                transitionToRoute Post PostLoaded (PostPage.init id)

            Just Route.Login ->
                ( { model | page = Login }, Cmd.none )

            Just Route.SignUp ->
                ( { model | page = SignUp }, Cmd.none )

            _ ->
                ( { model | page = NotFound }
                , Cmd.none
                )


type Msg
    = RouteChange (Maybe Route)
    | PostsLoaded (Result PostsPage.Model PostsPage.Model)
    | PostLoaded (Result PostPage.Model PostPage.Model)
    | PostMsg PostPage.Msg
    | NewPostMsg NewPostPage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( RouteChange maybeRoute, _ ) ->
            routeChange maybeRoute model

        ( PostsLoaded (Ok subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( PostsLoaded (Err subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( NewPostMsg subMsg, NewPost subModel ) ->
            let
                ( newSubModel, cmd ) =
                    NewPostPage.update subMsg subModel
            in
                ( { model | page = NewPost newSubModel }, Cmd.map NewPostMsg cmd )

        ( PostLoaded (Ok subModel), Post _ ) ->
            ( { model | page = Post subModel }, Cmd.none )

        ( PostLoaded (Err subModel), Post _ ) ->
            ( { model | page = Post subModel }, Cmd.none )

        ( PostMsg subMsg, Post subModel ) ->
            let
                ( newSubModel, cmd ) =
                    PostPage.update subMsg subModel
            in
                ( { model | page = Post newSubModel }, Cmd.map PostMsg cmd )

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
