module Pages.NewPost exposing (Model, init, view, Msg, update)

import Task exposing (Task)
import Html exposing (Html, div, input, span, textarea, button, text)
import Html.Attributes exposing (type_, placeholder, defaultValue)
import Html.Events exposing (onInput, onClick)
import Css
import GraphQL.Client.Http exposing (Error)
import Navigation
import Validate exposing (ifBlank)
import RemoteData exposing (RemoteData(..))
import Route exposing (modifyUrl, Route)
import Request.Post exposing (sendPostMutationRequest, PostResponse)
import Data.Misc exposing (WebData)
import Data.Session exposing (Session)
import Data.Post exposing (Post, NewPostVars, Id(Id))
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


view : Model -> Maybe Session -> Html Msg
view model session =
    div []
        [ (Views.ContentHeader.view
            (Just (Views.ContentHeader.viewBack GoBack))
            ( "new post", Nothing )
            Nothing
          )
        , div [ style stylesheet.container ]
            [ viewTextField ( model.title.value, "title", False ) SetTitle
            , viewTextArea ( model.body.value, "body..." ) SetBody
            , (case model.createRequest of
                NotAsked ->
                    viewButton "finish" (BeginPostCreationIfValid session)

                Loading ->
                    viewButton "loading..." (BeginPostCreationIfValid session)

                Success _ ->
                    div [] []

                Failure _ ->
                    viewButton "finish" (BeginPostCreationIfValid session)
              )
            ]
        ]


type Msg
    = SetTitle String
    | SetBody String
    | BeginPostCreationIfValid (Maybe Session)
    | PostCreationSuccess Post
    | PostCreationError Error
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

            BeginPostCreationIfValid session ->
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
                    case ( maybeErrors, session ) of
                        ( ( Nothing, Nothing ), Just session ) ->
                            ( { model | createRequest = Loading }
                            , createNewPostRequest { title = titleValue, body = bodyValue } session
                            )

                        ( ( maybeTitleError, maybeBodyError ), _ ) ->
                            ( { model
                                | title = Field titleValue maybeTitleError
                                , body = Field bodyValue maybeBodyError
                              }
                            , Cmd.none
                            )

            PostCreationSuccess post ->
                ( { model | createRequest = Success post }
                , modifyUrl (Route.Post (Id post.id))
                )

            PostCreationError error ->
                ( { model | createRequest = Failure error }, Cmd.none )

            GoBack ->
                ( model, Navigation.back 1 )


createNewPostRequest : NewPostVars -> Session -> Cmd Msg
createNewPostRequest newPostVars session =
    let
        handleResponse : PostResponse -> Msg
        handleResponse response =
            case response of
                Ok post ->
                    PostCreationSuccess post

                Err error ->
                    PostCreationError error
    in
        Task.attempt handleResponse (sendPostMutationRequest newPostVars session)



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
