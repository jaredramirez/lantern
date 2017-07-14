module Views.ContentHeader exposing (view)

import Html exposing (Html, div, span, text)
import Styles.ContentHeader exposing (Classes(..), namespace)


{ class } =
    namespace


view : String -> Html msg -> String Html msg
view left center right =
    div []
        [ span [] [ text left ]
        , center
        , span [] [ text right ]
        ]
