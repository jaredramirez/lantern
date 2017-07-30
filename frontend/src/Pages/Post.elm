module Pages.Post exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, span, text)
import Html.Attributes as HtmlAttr
import Task exposing (Task)
import Css
import GraphQL.Client.Http as GraphQLClient
import Navigation
import Route exposing (Route, href)
import Request.Post exposing (sendPostRequest)
import Data.Post exposing (Post, Id)
import Views.Header
import Views.SubHeader
import Views.ContentHeader
import Views.Cup
import Styles.Constants exposing (colors)


type alias Model =
    { post : Post
    , isFetching : Bool
    , fetchError : String
    }


initPost : Post
initPost =
    { id = ""
    , title = ""
    , body = ""
    , stars = []
    , author =
        { id = ""
        , firstName = ""
        , lastName = ""
        , email = ""
        }
    }


initModel : Model
initModel =
    { post = initPost
    , isFetching = True
    , fetchError = ""
    }


init : Id -> ( Model, Task Model Model )
init id =
    let
        handleSuccess : Post -> Model
        handleSuccess post =
            Model post False ""

        handleError : GraphQLClient.Error -> Model
        handleError _ =
            Model initPost False "Failed to fetch post."
    in
        ( initModel
        , Task.map handleSuccess (sendPostRequest id)
            |> Task.mapError handleError
        )


style =
    Css.asPairs >> HtmlAttr.style


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 20)
        ]
    , iconContainer =
        [ Css.displayFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        ]
    , tomatoText =
        [ Css.fontFamilies [ "Moon-Bold" ]
        , Css.color (Css.hex colors.tomato)
        , Css.marginLeft (Css.vw 1)
        ]
    , bodyContainer =
        [ Css.displayFlex
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        , Css.marginTop (Css.vh 3)
        ]
    , body =
        [ Css.fontFamilies [ "Moon-Bold" ]
        , Css.color (Css.hex colors.slate)
        , Css.padding (Css.vh 3)
        , Css.width (Css.vw 90)
        , Css.borderStyle Css.solid
        , Css.borderColor (Css.hex colors.slate)
        , Css.borderWidth (Css.vh 0.5)
        ]
    }


view : Model -> Html Msg
view { post, isFetching, fetchError } =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , case ( isFetching, fetchError ) of
            ( True, _ ) ->
                div [ style stylesheet.container ]
                    [ Views.Cup.view
                    , span [ style [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text "Please Wait..." ]
                    ]

            ( False, "" ) ->
                div []
                    [ (Views.ContentHeader.view
                        (Just (Views.ContentHeader.viewBack GoBack))
                        ( post.title
                        , Just (post.author.firstName ++ " " ++ post.author.lastName)
                        )
                        (Just Views.ContentHeader.viewNewPost)
                      )
                    , div [ style stylesheet.bodyContainer ]
                        [ span [ style stylesheet.body ] [ text post.body ]
                        ]
                    ]

            ( _, _ ) ->
                div
                    [ style stylesheet.container ]
                    [ div [ style stylesheet.iconContainer ]
                        [ Views.Cup.view
                        , span [ style stylesheet.tomatoText ] [ text "Uh Oh, Spaghettio" ]
                        ]
                    , span [ style [ Css.fontFamilies [ "Moon-Light" ] ] ] [ text fetchError ]
                    ]
        ]


type Msg
    = GoBack


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoBack ->
            ( model, Navigation.back 1 )
