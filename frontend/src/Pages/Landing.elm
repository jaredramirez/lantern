module Pages.Landing exposing (view)

import Html exposing (Html, div)
import Html.Attributes
import Css
import Styles.Page exposing (Classes(..), namespace)
import Views.Header
import Views.List exposing (viewLinks)


{ class } =
    namespace


styles =
    Css.asPairs >> Html.Attributes.style


contactInfo : List ( String, String )
contactInfo =
    [ ( "jaredramirez@me.com", "mailto:jaredramirez@me" )
    , ( "+1 (940) 368 - 7410", "" )
    ]


portfolioInfo : List ( String, String )
portfolioInfo =
    [ ( "Toptal", "https://www.toptal.com/resume/jared-ramirez" )
    , ( "Github", "https://github.com/jaredramirez" )
    , ( "Linkedin", "https://www.linkedin.com/in/jared-ramirez-830591125/" )
    ]


view : String -> Html msg
view _ =
    div [ class [ Backdrop ] ]
        [ Views.Header.view "Jared Ramirez" "Full Stack Dev"
        , div
            [ class [ Container ]
            , styles
                [ Css.width (Css.vw 100)
                , Css.height (Css.vh 50)
                , Css.alignItems Css.flexStart
                , Css.justifyContent Css.spaceAround
                ]
            ]
            [ (viewLinks "Contact" contactInfo 40)
            , (viewLinks "Portfolio" portfolioInfo 40)
            ]
        ]
