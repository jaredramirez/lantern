module Pages.Landing exposing (view)

import Html exposing (Html, div, a, span, text)
import Css
import Route exposing (Route(Posts, Login), href)
import Styles.Page exposing (Classes(Backdrop))
import Styles.Landing exposing (Classes(..))
import Constants exposing (colors)
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


view : Html msg
view =
    div [ pageNamespace.class [ Backdrop ] ]
        [ div
            [ class [ Container ] ]
            [ div [ class [ Label ] ] [ text "jump to" ]
            , div
                [ class [ BoxContainer ] ]
                [ viewBox "Posts" (Views.ArrowLeft.view colors.babyPowder) Posts
                , viewBox "Account" (Views.ArrowRight.view colors.babyPowder) Login
                ]
            ]
        ]
