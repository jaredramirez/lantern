module Main exposing (main)

import Html exposing (Html, Attribute, div, span, button, a, text, ul, li)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Task exposing (Task)
import Json.Decode exposing (decodeValue)
import Navigation
import Ports
import Route exposing (Route, href, fromLocation, newUrl)
import Data.Session exposing (Session)
import Views.Header as HeaderView
import Pages.Landing as LandingPage
import Pages.Posts as PostsPage
import Pages.NewPost as NewPostPage
import Pages.Post as PostPage
import Pages.Account as AccountPage
import Pages.Login as LoginPage exposing (ExternalMsg)
import Pages.SignUp as SignUpPage
import Pages.NotFound as NotFoundPage


type Page
    = NotFound
    | Landing
    | Posts PostsPage.Model
    | NewPost NewPostPage.Model
    | Post PostPage.Model
    | Account AccountPage.Model
    | Login LoginPage.Model
    | SignUp SignUpPage.Model


type alias Model =
    { page : Page
    , session : Maybe Session
    , afterLoginRoute : Route
    }


initalModel : Model
initalModel =
    { page = Landing
    , session = Nothing
    , afterLoginRoute = Route.Posts
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
            HeaderView.view ( model.session, NavigateToLogin, Logout )

        viewAuthenticated =
            (viewAuthenciatedPage model.session) << viewHeader

        viewMinimalHeader =
            HeaderView.viewMinimal ( model.session, NavigateToLogin, Logout )
    in
        case model.page of
            Landing ->
                viewMinimalHeader LandingPage.view

            Posts subModel ->
                viewHeader (PostsPage.view subModel)

            NewPost subModel ->
                viewAuthenticated
                    (NewPostPage.view subModel model.session
                        |> Html.map NewPostMsg
                    )

            Post subModel ->
                viewHeader
                    (PostPage.view subModel
                        |> Html.map PostMsg
                    )

            Account subModel ->
                viewHeader
                    (AccountPage.view subModel model.session
                        |> Html.map AccountMsg
                    )

            Login subModel ->
                viewHeader
                    (LoginPage.view ( subModel, model.afterLoginRoute )
                        |> Html.map LoginMsg
                    )

            SignUp subModel ->
                viewHeader
                    (SignUpPage.view subModel
                        |> Html.map SignUpMsg
                    )

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

        transition : (model -> Page) -> model -> ( Model, Cmd Msg )
        transition page initPage =
            ( { model | page = page initPage }, Cmd.none )

        requireAuthentication : Route -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
        requireAuthentication route ( model_, msg_ ) =
            if model_.session == Nothing then
                ( { model_ | afterLoginRoute = route }, Route.modifyUrl Route.Login )
            else
                ( model_, msg_ )
    in
        case maybeRoute of
            Just Route.Landing ->
                ( { model | page = Landing }, Cmd.none )

            Just Route.Posts ->
                transitionAndLoad Posts PostsLoad PostsPage.init

            Just Route.NewPost ->
                transition NewPost NewPostPage.init
                    |> requireAuthentication Route.NewPost

            Just (Route.Post id) ->
                transitionAndLoad Post PostLoad (PostPage.init id)

            Just Route.Account ->
                transition Account AccountPage.init
                    |> requireAuthentication Route.Account

            Just Route.Login ->
                transition Login (LoginPage.init model.afterLoginRoute)

            Just Route.SignUp ->
                transition SignUp SignUpPage.init

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
    | AccountMsg AccountPage.Msg
    | SignUpMsg SignUpPage.Msg
    | SetSession (Maybe Session)
    | NavigateToLogin
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

        ( AccountMsg subMsg, Account subModel ) ->
            let
                ( newSubModel, cmd ) =
                    AccountPage.update subMsg subModel
            in
                ( { model | page = Account newSubModel }, Cmd.map AccountMsg cmd )

        ( SignUpMsg subMsg, SignUp subModel ) ->
            let
                ( ( newSubModel, cmd ), externalMsg ) =
                    SignUpPage.update subMsg subModel
            in
                case externalMsg of
                    SignUpPage.NoOp ->
                        ( { model | page = SignUp newSubModel }, Cmd.map SignUpMsg cmd )

                    SignUpPage.SetSession session ->
                        ( { model
                            | page = SignUp newSubModel
                            , session = Just session
                          }
                        , Cmd.map SignUpMsg cmd
                        )

        ( SetSession maybeSession, _ ) ->
            ( { model | session = maybeSession }, Cmd.none )

        ( NavigateToLogin, _ ) ->
            ( { model | afterLoginRoute = Route.Posts }, newUrl Route.Account )

        ( Logout, _ ) ->
            ( { model | session = Nothing }, Ports.resetSession () )

        ( _, _ ) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map SetSession
        (Ports.onSessionChange
            (Result.toMaybe << decodeValue Data.Session.decoder)
        )


main : Program Never Model Msg
main =
    Navigation.program (fromLocation >> RouteChange)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
