module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Task exposing (Task)
import Navigation
import Route exposing (Route, href, fromLocation)
import Data.Session exposing (Session)
import Views.Header as HeaderView
import Pages.Landing as LandingPage
import Pages.Posts as PostsPage
import Pages.Post as PostPage
import Pages.NewPost as NewPostPage
import Pages.Login as LoginPage exposing (ExternalMsg)
import Pages.SignUp as SignUpPage
import Pages.NotFound as NotFoundPage


type Page
    = NotFound
    | Landing
    | Posts PostsPage.Model
    | Post PostPage.Model
    | NewPost NewPostPage.Model
    | Login LoginPage.Model
    | SignUp


type alias Model =
    { page : Page
    , session : Maybe Session
    }


initalModel : Model
initalModel =
    { page = Landing
    , session = Nothing
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    routeChange
        (fromLocation location)
        initalModel


viewAuthenciatedPage : Maybe Session -> Html Msg -> Html Msg
viewAuthenciatedPage session view =
    case session of
        Nothing ->
            div [] [ span [] [ text "Please Login" ] ]

        _ ->
            view


view : Model -> Html Msg
view model =
    let
        viewHeader =
            HeaderView.view model.session

        viewAuthenticated =
            (viewAuthenciatedPage model.session) << viewHeader

        viewMinimalHeader =
            HeaderView.viewMinimal model.session
    in
        case model.page of
            Landing ->
                viewMinimalHeader LandingPage.view

            Posts subModel ->
                viewHeader (PostsPage.view subModel)

            Post subModel ->
                viewHeader
                    (PostPage.view subModel
                        |> Html.map PostMsg
                    )

            NewPost subModel ->
                viewAuthenticated
                    (NewPostPage.view subModel
                        |> Html.map NewPostMsg
                    )

            Login subModel ->
                viewHeader
                    (LoginPage.view subModel
                        |> Html.map LoginMsg
                    )

            SignUp ->
                viewHeader SignUpPage.view

            _ ->
                viewMinimalHeader NotFoundPage.view


routeChange : Maybe Route -> Model -> ( Model, Cmd Msg )
routeChange maybeRoute model =
    let
        transitionAndLoad :
            (model -> Page)
            -> (Result e a -> Msg)
            -> ( model, Task e a )
            -> ( Model, Cmd Msg )
        transitionAndLoad page toMsg ( initPage, initTask ) =
            ( { model | page = page initPage }
            , Task.attempt toMsg initTask
            )

        transition : (model -> Page) -> model -> ( Model, Cmd msg )
        transition page initPage =
            ( { model | page = page initPage }, Cmd.none )
    in
        case maybeRoute of
            Just Route.Landing ->
                ( { model | page = Landing }, Cmd.none )

            Just Route.Posts ->
                transitionAndLoad Posts PostsLoad PostsPage.init

            Just (Route.Post id) ->
                transitionAndLoad Post PostLoad (PostPage.init id)

            Just Route.NewPost ->
                transition NewPost NewPostPage.init

            Just Route.Login ->
                transition Login LoginPage.init

            Just Route.SignUp ->
                ( { model | page = SignUp }, Cmd.none )

            _ ->
                ( { model | page = NotFound }
                , Cmd.none
                )


type Msg
    = RouteChange (Maybe Route)
    | PostsLoad (Result PostsPage.Model PostsPage.Model)
    | PostLoad (Result PostPage.Model PostPage.Model)
    | PostMsg PostPage.Msg
    | NewPostMsg NewPostPage.Msg
    | LoginMsg LoginPage.Msg
    | Logout


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.page ) of
        ( RouteChange maybeRoute, _ ) ->
            routeChange maybeRoute model

        ( PostsLoad (Ok subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( PostsLoad (Err subModel), Posts _ ) ->
            ( { model | page = Posts subModel }, Cmd.none )

        ( PostLoad (Ok subModel), Post _ ) ->
            ( { model | page = Post subModel }, Cmd.none )

        ( PostLoad (Err subModel), Post _ ) ->
            ( { model | page = Post subModel }, Cmd.none )

        ( NewPostMsg subMsg, NewPost subModel ) ->
            let
                ( newSubModel, cmd ) =
                    NewPostPage.update subMsg subModel
            in
                ( { model | page = NewPost newSubModel }, Cmd.map NewPostMsg cmd )

        ( PostMsg subMsg, Post subModel ) ->
            let
                ( newSubModel, cmd ) =
                    PostPage.update subMsg subModel
            in
                ( { model | page = Post newSubModel }, Cmd.map PostMsg cmd )

        ( LoginMsg subMsg, Login subModel ) ->
            let
                ( ( newSubModel, cmd ), externalMsg ) =
                    LoginPage.update subMsg subModel
            in
                case externalMsg of
                    LoginPage.NoOp ->
                        ( { model | page = Login newSubModel }, Cmd.map LoginMsg cmd )

                    LoginPage.SetSession session ->
                        ( { model
                            | page = Login newSubModel
                            , session = Just session
                          }
                        , Cmd.map LoginMsg cmd
                        )

        ( Logout, _ ) ->
            ( { model | session = Nothing }, Cmd.none )

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
