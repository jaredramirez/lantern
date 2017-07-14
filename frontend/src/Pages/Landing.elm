module Pages.Landing exposing (view)

import Html exposing (Html, div, a, span, text)
import Css
import Route exposing (Route(Feed, Landing), href)
import Styles.Constants exposing (colors)
import Styles.Page exposing (Classes(Backdrop))
import Styles.Landing exposing (Classes(..))
import Views.Header
import Views.ArrowRight
import Views.ArrowLeft


pageNamespace =
    Styles.Page.namespace


{ class } =
    Styles.Landing.namespace


viewBox : String -> Html msg -> Route -> Html msg
viewBox label icon route =
    a
        [ class [ Box ], href route ]
        [ span [ class [ Text ] ] [ text label ]
        , icon
        ]


view : String -> Html msg
view _ =
    div [ pageNamespace.class [ Backdrop ] ]
        [ Views.Header.view "lantern" "an arbitrarily named blog"
        , div
            [ class [ Container ] ]
            [ div [ class [ Label ] ] [ text "jump to" ]
            , div
                [ class [ BoxContainer ] ]
                [ viewBox "Feed" (Views.ArrowLeft.view colors.babyPowder) Feed
                , viewBox "Account" (Views.ArrowRight.view colors.babyPowder) Landing
                ]
            ]
        ]
