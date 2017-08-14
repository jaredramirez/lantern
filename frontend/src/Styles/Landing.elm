module Styles.Landing exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Constants exposing (fontLight, fontBold, colors)


type Classes
    = Container
    | Label
    | BoxContainer
    | Box
    | Text


namespace =
    withNamespace "landing"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            ]
        , class Label
            [ color (hex colors.tomato)
            , fontSize (vh 4)
            , fontFamilies [ fontBold ]
            , padding (vh 10)
            ]
        , class BoxContainer
            [ displayFlex
            , flexDirection row
            , alignItems center
            , justifyContent spaceAround
            , width (pct 100)
            ]
        , class Box
            [ backgroundColor (hex colors.cerulean)
            , height (vh 35)
            , width (vh 35)
            , margin (vh 2)
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , textDecoration none
            ]
        , class Text
            [ color (hex colors.babyPowder)
            , fontSize (vh 4)
            , fontFamilies [ fontLight ]
            ]
        ]
