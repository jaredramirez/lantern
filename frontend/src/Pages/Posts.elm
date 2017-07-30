module Pages.Posts exposing (Model, init, view)

import Html exposing (Html, a, div, span, text)
import Task exposing (Task)
import GraphQL.Client.Http as GraphQLClient
import Html.Attributes as HtmlAttr
import Css
import Route exposing (href, Route)
import Pages.Utils exposing (PageLoadError, pageLoadError)
import Data.Post exposing (Post, Posts, stringToId)
import Request.Post exposing (sendPostsRequest)
import Views.PostPreview
import Views.Header
import Views.SubHeader
import Views.ContentHeader
import Views.Cup
import Styles.Constants exposing (colors)
import Styles.Posts exposing (Classes(..), namespace)


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


{ class } =
    namespace


style =
    Css.asPairs >> HtmlAttr.style


viewPost : Post -> Html msg
viewPost post =
    a
        [ href (Route.Post (stringToId post.id))
        , class [ Button ]
        ]
        [ Views.PostPreview.view post ]


view : Model -> Html msg
view { posts, isFetching, fetchError } =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , case ( isFetching, fetchError ) of
            ( True, _ ) ->
                div [ class [ Container ] ]
                    [ Views.Cup.view
                    , span [ style [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text "Please Wait..." ]
                    ]

            ( False, "" ) ->
                div []
                    (List.concat
                        [ [ (Views.ContentHeader.view
                                Nothing
                                ( "Posts", Nothing )
                                (Just Views.ContentHeader.viewNewPost)
                            )
                          ]
                        , (List.map
                            viewPost
                            posts
                          )
                        ]
                    )

            ( _, _ ) ->
                div
                    [ class [ Container ] ]
                    [ div [ class [ IconContainer ] ]
                        [ Views.Cup.view
                        , span [ class [ TomatoText ] ] [ text "Uh Oh, Spaghettio" ]
                        ]
                    , span [ style [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text fetchError ]
                    ]
        ]
