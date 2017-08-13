module Pages.NotFound exposing (view)

import Html exposing (Html, div, span, a, text)
import Html.Attributes
import Css
import Route exposing (Route(Landing), href)
import Styles.Page exposing (Classes(..), namespace)
import Views.Cup
import Views.List


{ class } =
    namespace


styles =
    Css.asPairs >> Html.Attributes.style


quotes =
    [ "\"I could spend the rest of my life reading, just satisfying my curiosity\"."
    , "Malcom X"
    ]


view : Html msg
view =
    div [ class [ Backdrop ] ]
        [ div
            [ class [ Container ]
            , styles
                [ Css.height (Css.vh 50)
                , Css.flexDirection Css.column
                , Css.justifyContent Css.spaceAround
                ]
            ]
            [ a
                [ href Landing, class [ Container, Link ] ]
                [ Views.Cup.view
                , span [ class [ Text ], styles [ Css.marginLeft (Css.vw 1) ] ]
                    [ text "Back to Landing" ]
                ]
            , Views.List.viewItems "uh oh, there's nothing here" quotes 55
            ]
        ]
