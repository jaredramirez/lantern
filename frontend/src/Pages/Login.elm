module Pages.Login exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import Validate exposing (ifBlank, ifInvalidEmail)
import RemoteData exposing (RemoteData(..))
import Data.Session exposing (Session)
import Data.Misc exposing (WebData)
import Pages.Misc exposing (Field, initField)
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
view model =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , div [ style stylesheet.container ]
            [ span [ style stylesheet.label ] [ text "Login" ]
            , viewTextField ( model.email.value, "Email", False ) SetEmail
            , div [ style stylesheet.buttonContainer ]
                [ viewTextField
                    ( model.password.value, "Password", not model.showPassword )
                    SetPassword
                , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
                ]
            , viewButton "Submit" BeginLoginIfValid
            ]
        ]


type Msg
    = SetEmail String
    | SetPassword String
    | TogglePasswordVisible
    | BeginLoginIfValid
    | LoginSuccess
    | LoginError


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
                        ( List.head (emailValidator passwordValue)
                        , List.head (passwordValidator passwordValue)
                        )
                in
                    case maybeErrors of
                        ( Nothing, Nothing ) ->
                            ( model, Cmd.none )

                        ( maybeEmailError, maybePasswordError ) ->
                            ( { model
                                | email = Field emailValue maybeEmailError
                                , password = Field passwordValue maybePasswordError
                              }
                            , Cmd.none
                            )

            LoginSuccess ->
                ( model, Cmd.none )

            LoginError ->
                ( model, Cmd.none )



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
        [ Css.fontFamilies [ "Moon-Bold" ]
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
