module Pages.Feed exposing (view)

import Html exposing (Html, div, text)
import Views.Header
import Views.SubHeader


view : Html msg
view =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        ]
