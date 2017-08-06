module Styles.List exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Constants exposing (fontLight, fontBold, colors)


type Classes
    = Container
    | Title
    | Line
    | Item


namespace =
    withNamespace "list"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent spaceAround
            ]
        , class Title
            [ fontSize (vh 4)
            , fontFamilies [ fontBold ]
            , color (hex colors.slate)
            , textDecoration none
            ]
        , class Line
            [ height (vh 0.5)
            , backgroundColor (hex colors.tomato)
            , margin (vh 1)
            , marginBottom (vh 2)
            ]
        , class Item
            [ fontSize (vh 2.5)
            , fontFamilies [ fontLight ]
            , color (hex colors.slate)
            , margin (vh 2)
            ]
        ]
