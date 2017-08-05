module Pages.Login exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import Pages.Utils exposing (Field, initField, isNothing, validateOne)
import Views.Header
import Views.SubHeader
import Views.Form exposing (viewTextField, viewButton)


type alias Model =
    { email : Field
    , password : Field
    , showPassword : Bool
    , isLoggingIn : Bool
    }


init : Model
init =
    Model initField initField False False


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 40)
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


style =
    Css.asPairs >> Html.Attributes.style


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
                    ( model.password.value
                    , "Password"
                    , not model.showPassword
                    )
                    SetPassword
                , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
                ]
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
    case msg of
        SetEmail emailValue ->
            ( { model | email = Field emailValue model.email.error }, Cmd.none )

        SetPassword passwordValue ->
            ( { model | password = Field passwordValue model.password.error }, Cmd.none )

        TogglePasswordVisible ->
            ( { model | showPassword = not model.showPassword }, Cmd.none )

        BeginLoginIfValid ->
            ( model, Cmd.none )

        LoginSuccess ->
            ( model, Cmd.none )

        LoginError ->
            ( model, Cmd.none )
