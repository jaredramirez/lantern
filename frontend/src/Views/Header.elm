module Views.Header exposing (view)

import Html exposing (Html, div, span, a, text)
import Styles.Header exposing (Classes(..), namespace)
import Route exposing (Route, href)


{ class } =
    namespace


view : String -> String -> Html msg
view title subTitle =
    div [ class [ Bar ] ]
        [ span [ class [ Title ] ] [ text title ]
        , span [ class [ SubTitle ] ] [ text subTitle ]
        ]
