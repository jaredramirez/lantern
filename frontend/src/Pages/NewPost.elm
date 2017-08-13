module Pages.NewPost exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, input, span, textarea, button, text)
import Html.Attributes exposing (type_, placeholder, defaultValue)
import Html.Events exposing (onInput, onClick)
import Css
import Navigation
import Validate exposing (ifBlank)
import RemoteData exposing (RemoteData(..))
import Data.Misc exposing (WebData)
import Data.Post exposing (Post)
import Pages.Misc exposing (Field, initField)
import Constants exposing (colors)
import Views.ContentHeader
import Views.Form exposing (viewTextField, viewTextArea, viewButton)


-- MODEL/VIEW/UPDATE


type alias Model =
    { title : Field
    , body : Field
    , createRequest : WebData Post
    }


init : Model
init =
    Model initField initField NotAsked


view : Model -> Html Msg
view model =
    div []
        [ (Views.ContentHeader.view
            (Just (Views.ContentHeader.viewBack GoBack))
            ( "new post", Nothing )
            Nothing
          )
        , div [ style stylesheet.container ]
            [ viewTextField ( model.title.value, "title", False ) SetTitle
            , viewTextArea ( model.body.value, "body..." ) SetBody
            , viewButton "finish" BeginPostCreationIfValid
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
    let
        titleValidator =
            ifBlank "Title is required"

        bodyValidator =
            ifBlank "Body is required"
    in
        case msg of
            SetTitle titleValue ->
                let
                    maybeError =
                        List.head (titleValidator titleValue)
                in
                    ( { model | title = Field titleValue maybeError }, Cmd.none )

            SetBody bodyValue ->
                let
                    maybeError =
                        List.head (bodyValidator bodyValue)
                in
                    ( { model | body = Field bodyValue maybeError }, Cmd.none )

            BeginPostCreationIfValid ->
                let
                    titleValue =
                        model.title.value

                    bodyValue =
                        model.body.value

                    maybeErrors =
                        ( List.head (titleValidator titleValue)
                        , List.head (bodyValidator bodyValue)
                        )
                in
                    case maybeErrors of
                        ( Nothing, Nothing ) ->
                            ( model, Cmd.none )

                        ( maybeTitleError, maybeBodyError ) ->
                            ( { model
                                | title = Field titleValue maybeTitleError
                                , body = Field bodyValue maybeBodyError
                              }
                            , Cmd.none
                            )

            PostCreationSuccess ->
                ( model, Navigation.back 1 )

            PostCreationError ->
                ( model, Cmd.none )

            GoBack ->
                ( model, Navigation.back 1 )



-- STYLES


style =
    Css.asPairs >> Html.Attributes.style


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 65)
        ]
    }
