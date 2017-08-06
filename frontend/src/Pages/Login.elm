module Pages.Login exposing (Model, init, view, Msg, update)

import Task exposing (Task)
import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import GraphQL.Client.Http exposing (Error)
import Validate exposing (ifBlank, ifInvalidEmail)
import RemoteData exposing (RemoteData(..))
import Request.Session exposing (AuthenticateResponse, sendAuthenticateRequest)
import Data.Session exposing (Session)
import Data.Misc exposing (WebData)
import Pages.Misc exposing (Field, initField)
import Constants exposing (fontBold)
import Views.Header
import Views.SubHeader
import Views.Form exposing (viewTextField, viewButton)


type alias Model =
    { email : Field
    , password : Field
    , showPassword : Bool
    , loginRequest : WebData Session
    }


init : Model
init =
    Model initField initField False NotAsked


view : Model -> Html Msg
view { email, password, showPassword, loginRequest } =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , div [ style stylesheet.container ]
            [ span [ style stylesheet.label ] [ text "Login" ]
            , viewTextField ( email.value, "Email", False ) SetEmail
            , div [ style stylesheet.buttonContainer ]
                [ viewTextField
                    ( password.value, "Password", not showPassword )
                    SetPassword
                , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
                ]
            , case loginRequest of
                NotAsked ->
                    viewButton "Submit" BeginLoginIfValid

                Loading ->
                    viewButton "Loading..." BeginLoginIfValid

                Success session ->
                    div [] [ span [] [ text "SUCCESS" ] ]

                Failure _ ->
                    div []
                        [ viewButton "Submit" BeginLoginIfValid
                        , span [] [ text "Failed." ]
                        ]
            ]
        ]


type Msg
    = SetEmail String
    | SetPassword String
    | TogglePasswordVisible
    | BeginLoginIfValid
    | LoginSuccess Session
    | LoginError Error


update : Msg -> Model -> ( Model, Cmd Msg )
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
                    ( { model | email = Field emailValue maybeError }, Cmd.none )

            SetPassword passwordValue ->
                let
                    maybeError =
                        List.head (passwordValidator passwordValue)
                in
                    ( { model | password = Field passwordValue maybeError }, Cmd.none )

            TogglePasswordVisible ->
                ( { model | showPassword = not model.showPassword }, Cmd.none )

            BeginLoginIfValid ->
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
                            ( { model | loginRequest = Loading }
                            , loginRequest emailValue passwordValue
                            )

                        ( maybeEmailError, maybePasswordError ) ->
                            ( { model
                                | email = Field emailValue maybeEmailError
                                , password = Field passwordValue maybePasswordError
                              }
                            , Cmd.none
                            )

            LoginSuccess session ->
                ( { model | loginRequest = Success session }, Cmd.none )

            LoginError error ->
                ( { model | loginRequest = Failure error }, Cmd.none )


loginRequest : String -> String -> Cmd Msg
loginRequest email password =
    let
        handleResponse : AuthenticateResponse -> Msg
        handleResponse response =
            case response of
                Ok session ->
                    LoginSuccess session

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
    }
