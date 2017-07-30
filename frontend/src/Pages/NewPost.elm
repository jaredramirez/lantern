module Pages.NewPost exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, input, span, textarea, button, text)
import Html.Attributes exposing (type_, placeholder, defaultValue)
import Html.Events exposing (onInput, onClick)
import Navigation
import Styles.NewPost exposing (Classes(..), namespace)
import Views.Header
import Views.SubHeader
import Views.ContentHeader


-- INTERNAL


type alias Field =
    { value : String
    , error : Maybe String
    }


isNothing : Maybe val -> Bool
isNothing maybe =
    if maybe == Nothing then
        True
    else
        False


validateOne : String -> Maybe String
validateOne value =
    let
        errorMessage =
            "Required"
    in
        if value == "" then
            Just errorMessage
        else
            Nothing


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



-- MODEL/VIEW/UPDATE


type alias Model =
    { title : Field
    , body : Field
    , isCreating : Bool
    }


{ class } =
    namespace


init : Model
init =
    { title = Field "" Nothing
    , body = Field "" Nothing
    , isCreating = False
    }


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
        , div [ class [ Container ] ]
            [ input
                [ type_ "text"
                , placeholder "Title"
                , defaultValue model.title.value
                , onInput SetTitle
                , class [ Input, InputTitle ]
                ]
                []
            , textarea
                [ placeholder "Body..."
                , defaultValue model.body.value
                , onInput SetBody
                , class [ Input, InputBody ]
                ]
                []
            , span [ class [ Line ] ] []
            , button [ onClick BeginPostCreationIfValid, class [ Button ] ] [ text "Finish" ]
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
