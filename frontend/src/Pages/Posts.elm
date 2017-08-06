module Pages.Posts exposing (Model, init, view)

import Html exposing (Html, a, div, span, text)
import Task exposing (Task)
import GraphQL.Client.Http as GraphQLClient
import Html.Attributes as HtmlAttr
import Css
import RemoteData exposing (RemoteData(..))
import Route exposing (href, Route)
import Data.Misc exposing (WebData)
import Data.Post exposing (Post, Posts, stringToId)
import Request.Post exposing (sendPostsRequest)
import Constants exposing (fontLight)
import Views.PostPreview
import Views.Header
import Views.SubHeader
import Views.ContentHeader
import Views.Cup
import Styles.Constants exposing (colors)
import Styles.Posts exposing (Classes(..), namespace)


type alias Model =
    { data : WebData Posts }


initModel : Model
initModel =
    Model Loading


init : ( Model, Task Model Model )
init =
    let
        handleSuccess : Posts -> Model
        handleSuccess posts =
            Model (Success posts)

        handleError : GraphQLClient.Error -> Model
        handleError error =
            Model (Failure error)
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
view { data } =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , let
            placeholder : String -> Html msg
            placeholder message =
                div [ class [ Container ] ]
                    [ Views.Cup.view
                    , span [ style [ Css.fontFamilies [ fontLight ] ] ] [ text message ]
                    ]

            loadingPlaceholder : Html msg
            loadingPlaceholder =
                placeholder "Please wait..."
          in
            case data of
                NotAsked ->
                    loadingPlaceholder

                Loading ->
                    loadingPlaceholder

                Failure _ ->
                    placeholder "Failed to load."

                Success posts ->
                    div []
                        (List.concat
                            [ [ (Views.ContentHeader.view
                                    Nothing
                                    ( "posts", Nothing )
                                    (Just Views.ContentHeader.viewNewPost)
                                )
                              ]
                            , (List.map
                                viewPost
                                posts
                              )
                            ]
                        )
        ]
