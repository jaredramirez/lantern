module Pages.Login exposing (Model, init, view, Msg, ExternalMsg(..), update)

import Task exposing (Task)
import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import Navigation
import GraphQL.Client.Http exposing (Error)
import Validate exposing (ifBlank, ifInvalidEmail)
import RemoteData exposing (RemoteData(..))
import Ports
import Route exposing (Route, newUrl)
import Request.Session exposing (AuthenticateResponse, sendAuthenticateRequest)
import Data.Session exposing (Session)
import Data.Misc exposing (WebData)
import Pages.Misc exposing (Field, initField)
import Constants exposing (colors, fontBold)
import Views.Form exposing (viewTextField, viewButton)


type alias Model =
    { email : Field
    , password : Field
    , showPassword : Bool
    , loginRequest : WebData Session
    , afterLoginRoute : Route
    }


init : Route -> Model
init route =
    Model initField initField False NotAsked route


view : ( Model, Route ) -> Html Msg
view ( { email, password, showPassword, loginRequest }, afterLoginRoute ) =
    div [ style stylesheet.container ]
        [ span [ style stylesheet.label ] [ text "LOGIN" ]
        , viewTextField ( email.value, "email", False ) SetEmail
        , div [ style stylesheet.buttonContainer ]
            [ viewTextField
                ( password.value, "password", not showPassword )
                SetPassword
            , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
            ]
        , case loginRequest of
            NotAsked ->
                viewButton "SUBMIT" (BeginLoginIfValid afterLoginRoute)

            Loading ->
                viewButton "LOADING..." (BeginLoginIfValid afterLoginRoute)

            Success session ->
                div [] []

            Failure _ ->
                div []
                    [ viewButton "SUBMIT" (BeginLoginIfValid afterLoginRoute)
                    , span [] [ text "Failed to login." ]
                    ]
        , span [ style stylesheet.signUp ] [ text "Or Sign Up" ]
        ]


type ExternalMsg
    = SetSession Session
    | NoOp


type Msg
    = SetEmail String
    | SetPassword String
    | TogglePasswordVisible
    | BeginLoginIfValid Route
    | LoginSuccess Session Route
    | LoginError Error


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
update msg model =
    let
        emailValidator =
            ifInvalidEmail "Must be valid email"

        passwordValidator =
            ifBlank "Password is required"
    in
        case msg of
            SetEmail emailValue ->
                let
                    maybeError =
                        List.head (emailValidator emailValue)
                in
                    ( ( { model | email = Field emailValue maybeError }, Cmd.none ), NoOp )

            SetPassword passwordValue ->
                let
                    maybeError =
                        List.head (passwordValidator passwordValue)
                in
                    ( ( { model | password = Field passwordValue maybeError }, Cmd.none ), NoOp )

            TogglePasswordVisible ->
                ( ( { model | showPassword = not model.showPassword }, Cmd.none ), NoOp )

            BeginLoginIfValid route ->
                let
                    emailValue =
                        model.email.value

                    passwordValue =
                        model.password.value

                    maybeErrors =
                        ( List.head (emailValidator emailValue)
                        , List.head (passwordValidator passwordValue)
                        )
                in
                    case maybeErrors of
                        ( Nothing, Nothing ) ->
                            ( ( { model | loginRequest = Loading }
                              , loginRequest emailValue passwordValue route
                              )
                            , NoOp
                            )

                        ( maybeEmailError, maybePasswordError ) ->
                            ( ( { model
                                    | email = Field emailValue maybeEmailError
                                    , password = Field passwordValue maybePasswordError
                                }
                              , Cmd.none
                              )
                            , NoOp
                            )

            LoginSuccess session afterLoginRoute ->
                ( ( { model | loginRequest = Success session }
                  , Cmd.batch [ Route.newUrl afterLoginRoute, Ports.saveSession session ]
                  )
                , SetSession session
                )

            LoginError error ->
                ( ( { model | loginRequest = Failure error }, Cmd.none ), NoOp )


loginRequest : String -> String -> Route -> Cmd Msg
loginRequest email password afterLoginRoute =
    let
        handleResponse : AuthenticateResponse -> Msg
        handleResponse response =
            case response of
                Ok session ->
                    LoginSuccess session afterLoginRoute

                Err error ->
                    LoginError error
    in
        Task.attempt handleResponse (sendAuthenticateRequest { email = email, password = password })



-- STYLES


style =
    Css.asPairs >> Html.Attributes.style


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 50)
        ]
    , label =
        [ Css.fontFamilies [ fontBold ]
        , Css.fontSize (Css.vw 2)
        , Css.color (Css.hex colors.tomato)
        ]
    , buttonContainer =
        [ Css.displayFlex
        , Css.flexDirection Css.row
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        ]
    , button =
        [ Css.position Css.absolute
        , Css.marginLeft (Css.pct 25)
        ]
    , signUp =
        [ Css.fontFamilies [ fontBold ]
        , Css.fontSize (Css.vw 2)
        , Css.color (Css.hex colors.tomato)
        , Css.cursor Css.pointer
        ]
    }
