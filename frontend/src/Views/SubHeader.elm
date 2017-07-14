module Views.SubHeader exposing (view)

import Html exposing (Html, div, a, span, text)
import Styles.SubHeader exposing (Classes(..), namespace)
import Route exposing (Route(Feed, Landing), href)


{ class } =
    namespace


view : Html msg
view =
    div [ class [ Container ] ]
        [ a [ class [ Section ], href Feed ] [ span [ class [ Text ] ] [ text "Feed" ] ]
        , a [ class [ Section ], href Landing ] [ span [ class [ Text ] ] [ text "Account" ] ]
        ]
