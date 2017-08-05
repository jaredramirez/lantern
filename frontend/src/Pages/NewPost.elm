module Pages.NewPost exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, input, span, textarea, button, text)
import Html.Attributes exposing (type_, placeholder, defaultValue)
import Html.Events exposing (onInput, onClick)
import Css
import Navigation
import Pages.Utils exposing (Field, initField, isNothing, validateOne)
import Views.Header
import Views.SubHeader
import Views.ContentHeader
import Views.Form exposing (viewTextField, viewTextArea, viewButton)
import Styles.Constants exposing (colors)


-- MODEL/VIEW/UPDATE


type alias Model =
    { title : Field
    , body : Field
    , isCreating : Bool
    }


init : Model
init =
    Model initField initField False


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 65)
        ]
    , line =
        [ Css.height (Css.vh 0.5)
        , Css.width (Css.vw 80)
        , Css.backgroundColor (Css.hex colors.cerulean)
        , Css.margin (Css.vh 1)
        , Css.marginBottom (Css.vh 2)
        ]
    }


style =
    Css.asPairs >> Html.Attributes.style


view : Model -> Html Msg
view model =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , (Views.ContentHeader.view
            (Just (Views.ContentHeader.viewBack GoBack))
            ( "New Post", Nothing )
            Nothing
          )
        , div [ style stylesheet.container ]
            [ viewTextField ( model.title.value, "Title", False ) SetTitle
            , viewTextArea ( model.body.value, "Body..." ) SetBody
            , span [ style stylesheet.line ] []
            , viewButton "Finish" BeginPostCreationIfValid
            ]
        ]


type Msg
    = SetTitle String
    | SetBody String
    | BeginPostCreationIfValid
    | PostCreationSuccess
    | PostCreationError
    | GoBack


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetTitle titleValue ->
            let
                maybeError =
                    validateOne titleValue
            in
                ( { model | title = Field titleValue maybeError }, Cmd.none )

        SetBody bodyValue ->
            let
                maybeError =
                    validateOne bodyValue
            in
                ( { model | body = Field bodyValue maybeError }, Cmd.none )

        BeginPostCreationIfValid ->
            let
                titleValue =
                    model.title.value

                bodyValue =
                    model.body.value

                ( isValid, maybeTitleError, maybeBodyError ) =
                    validateAll titleValue bodyValue

                nextCmd =
                    if isValid then
                        -- TODO: Add call to create post
                        Cmd.none
                    else
                        Cmd.none
            in
                ( { model
                    | title = Field titleValue maybeTitleError
                    , body = Field bodyValue maybeTitleError
                  }
                , nextCmd
                )

        PostCreationSuccess ->
            ( model, Navigation.back 1 )

        PostCreationError ->
            ( model, Cmd.none )

        GoBack ->
            ( model, Navigation.back 1 )



-- INTERNAL


validateAll : String -> String -> ( Bool, Maybe String, Maybe String )
validateAll title body =
    let
        titleError =
            validateOne title

        bodyError =
            validateOne body

        isValid =
            List.all isNothing [ titleError, bodyError ]
    in
        ( isValid, titleError, bodyError )
