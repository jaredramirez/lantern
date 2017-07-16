module Pages.Feed exposing (Model, Msg, init, view, update)

import Html exposing (Html, div, span, text)
import Task exposing (Task)
import GraphQL.Client.Http as GraphQLClient
import Pages.Utils exposing (PageLoadError, pageLoadError)
import Data.Post exposing (Posts)
import Request.Post exposing (postsRequest, PostsResponse)
import Views.Post
import Views.Header
import Views.SubHeader
import Views.ContentHeader


sendPostsRequest : Task GraphQLClient.Error Posts
sendPostsRequest =
    GraphQLClient.sendQuery "http://localhost:3000/graphql" postsRequest


type alias Model =
    { posts : Posts }


initModel : Model
initModel =
    Model []


init : ( Model, Task PageLoadError Model )
init =
    let
        handleError =
            \_ -> pageLoadError "Failed to load page"
    in
        ( initModel
        , Task.map Model sendPostsRequest
            |> Task.mapError handleError
        )


view : Model -> Html Msg
view model =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , Views.ContentHeader.view "" "Feed" "New Post"
        , if model.posts /= [] then
            div []
                (List.map
                    Views.Post.view
                    model.posts
                )
          else
            div [] []
        ]


type Msg
    = Nothing


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Nothing ->
            ( model, Cmd.none )
