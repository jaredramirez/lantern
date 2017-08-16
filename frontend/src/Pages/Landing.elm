module Pages.Landing exposing (view)

import Html exposing (Html, div, a, span, text)
import Css
import Route exposing (Route(Posts, Account), href)
import Styles.Misc exposing (getClass)
import Styles.Page exposing (Classes(Backdrop))
import Styles.Landing exposing (Classes(..))
import Constants exposing (colors)
import Views.ArrowRight
import Views.ArrowLeft


pageNamespace =
    Styles.Page.namespace


class =
    getClass Styles.Landing.namespace


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
                [ viewBox "POSTS" (Views.ArrowLeft.view colors.babyPowder) Posts
                , viewBox "ACCOUNT" (Views.ArrowRight.view colors.babyPowder) Account
                ]
            ]
        ]
