module Pages.Post exposing (Model, init, view, Msg, update)

import Html exposing (Html, div, span, text)
import Html.Attributes as HtmlAttr
import Task exposing (Task)
import Css
import GraphQL.Client.Http as GraphQLClient
import Navigation
import RemoteData exposing (RemoteData(..))
import Route exposing (Route, href)
import Data.Misc exposing (WebData)
import Data.Post exposing (Post, Posts)
import Request.Post exposing (sendPostRequest)
import Data.Post exposing (Post, Id(Id))
import Constants exposing (fontLight, fontBold, colors)
import Views.ContentHeader
import Views.Cup


type alias Model =
    { data : WebData Post }


initModel : Model
initModel =
    { data = Loading
    }


init : Id -> ( Model, Task Model Model )
init id =
    let
        handleSuccess : Post -> Model
        handleSuccess post =
            Model (Success post)

        handleError : GraphQLClient.Error -> Model
        handleError error =
            Model (Failure error)
    in
        ( initModel
        , Task.map handleSuccess (sendPostRequest id)
            |> Task.mapError handleError
        )


view : Model -> Html Msg
view { data } =
    let
        placeholder : String -> Html msg
        placeholder message =
            div [ style stylesheet.container ]
                [ Views.Cup.view
                , span [ style [ Css.fontFamilies [ fontLight ] ] ] [ text message ]
                ]

        loadingPlaceholder : Html msg
        loadingPlaceholder =
            placeholder "Please Wait..."
    in
        case data of
            NotAsked ->
                loadingPlaceholder

            Loading ->
                loadingPlaceholder

            Failure _ ->
                placeholder "Error"

            Success post ->
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


type Msg
    = GoBack


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GoBack ->
            ( model, Navigation.back 1 )



-- STYLES


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
        [ Css.fontFamilies [ fontBold ]
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
        [ Css.fontFamilies [ fontBold ]
        , Css.color (Css.hex colors.slate)
        , Css.padding (Css.vh 3)
        , Css.width (Css.vw 90)
        , Css.borderStyle Css.solid
        , Css.borderColor (Css.hex colors.slate)
        , Css.borderWidth (Css.vh 0.5)
        ]
    }
