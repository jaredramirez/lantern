module Views.ContentHeader exposing (view)

import Html exposing (Html, Attribute, div, a, span, text)
import Route exposing (Route, href)
import Styles.ContentHeader exposing (Classes(..), namespace)


{ class } =
    namespace


view : Html msg -> String -> String -> String -> Html msg
view viewLeft center centerSub right =
    div [ class [ Container ] ]
        [ div [ class [ Flex ] ] [ viewLeft ]
        , div [ class [ MainContainer ] ]
            [ span [ class [ MainText ] ] [ text center ]
            , span [ class [ SubText ] ] [ text centerSub ]
            ]
        , span [ class [ Link ] ] [ text right ]
        ]
