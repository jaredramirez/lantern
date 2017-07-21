module Styles.Posts exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Styles.Constants exposing (colors)


type Classes
    = Button
    | Container
    | IconContainer
    | TomatoText


namespace =
    withNamespace "posts"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Button
            [ textDecoration none ]
        , class Container
            [ displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent spaceAround
            , height (vh 20)
            ]
        , class IconContainer
            [ displayFlex
            , alignItems center
            , justifyContent center
            ]
        , class TomatoText
            [ fontFamilies [ "Moon-Bold" ]
            , color (hex colors.tomato)
            , marginLeft (vw 1)
            ]
        ]
