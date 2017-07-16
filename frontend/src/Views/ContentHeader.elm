module Views.ContentHeader exposing (view)

import Html exposing (Html, div, span, text)
import Styles.ContentHeader exposing (Classes(..), namespace)


{ class } =
    namespace


view : String -> String -> String -> Html msg
view left center right =
    div [ class [ Container ] ]
        [ span [ class [ SubText ] ] [ text left ]
        , span [ class [ MainText ] ] [ text center ]
        , span [ class [ SubText ] ] [ text right ]
        ]
