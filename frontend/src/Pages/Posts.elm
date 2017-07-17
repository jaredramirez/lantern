module Pages.Posts exposing (Model, init, view)

import Html exposing (Html, div, span, text)
import Task exposing (Task)
import GraphQL.Client.Http as GraphQLClient
import Html.Attributes
import Css
import Pages.Utils exposing (PageLoadError, pageLoadError)
import Data.Post exposing (Posts)
import Request.Post exposing (postsRequest, PostsResponse)
import Views.Post
import Views.Header
import Views.SubHeader
import Views.ContentHeader
import Views.Cup
import Styles.Constants exposing (colors)


sendPostsRequest : Task GraphQLClient.Error Posts
sendPostsRequest =
    GraphQLClient.sendQuery "http://localhost:3000/graphql" postsRequest


type alias Model =
    { posts : Posts
    , isFetching : Bool
    , fetchError : String
    }


initModel : Model
initModel =
    Model [] True ""


init : ( Model, Task Model Model )
init =
    let
        handleSuccess : Posts -> Model
        handleSuccess posts =
            Model posts False ""

        handleError : GraphQLClient.Error -> Model
        handleError _ =
            Model [] False "Failed to fetch posts. Please try again in a few minutes"
    in
        ( initModel
        , Task.map handleSuccess sendPostsRequest
            |> Task.mapError handleError
        )


styles =
    Css.asPairs >> Html.Attributes.style


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 20)
        ]
    , iconContianer =
        [ Css.displayFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        ]
    , tomatoText =
        [ Css.fontFamilies [ "Moon-Bold" ]
        , Css.color (Css.hex colors.tomato)
        , Css.marginLeft (Css.vw 1)
        ]
    }


view : Model -> Html msg
view { posts, isFetching, fetchError } =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , case ( isFetching, fetchError ) of
            ( True, _ ) ->
                div [ styles stylesheet.container ]
                    [ Views.Cup.view
                    , span [ styles [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text "Please Wait..." ]
                    ]

            ( False, "" ) ->
                div []
                    (List.concat
                        [ [ (Views.ContentHeader.view "" "Posts" "New Post") ]
                        , (List.map
                            Views.Post.view
                            posts
                          )
                        ]
                    )

            ( _, _ ) ->
                div
                    [ styles stylesheet.container ]
                    [ div [ styles stylesheet.iconContianer ]
                        [ Views.Cup.view
                        , span [ styles stylesheet.tomatoText ] [ text "Uh Oh, Spaghettio" ]
                        ]
                    , span [ styles [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text fetchError ]
                    ]
        ]
