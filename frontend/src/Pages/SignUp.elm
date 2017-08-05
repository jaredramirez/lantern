module Pages.SignUp exposing (view)

import Html exposing (Html, div, span, text)
import Views.Header
import Views.SubHeader


view : Html msg
view =
    div []
        [ Views.Header.view "lantern" "an arbitrariliy named blog"
        , Views.SubHeader.view
        , span [] [ text "SignUp" ]
        ]
