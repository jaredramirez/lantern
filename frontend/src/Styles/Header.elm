module Styles.Header exposing (Classes(..), namespace, css)

import Css exposing (..)
import Css.Namespace
import Html.CssHelpers exposing (withNamespace)
import Constants exposing (fontLight, fontBold, colors)


type Classes
    = Bar
    | Title
    | SubTitle


namespace =
    withNamespace "header"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Bar
            [ backgroundColor (hex colors.slate)
            , height (vh 15)
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            ]
        , class Title
            [ color (hex colors.tomato)
            , fontSize (vh 6)
            , fontFamilies [ fontBold ]
            ]
        , class SubTitle
            [ color (hex "FE5D4C")
            , fontSize (vh 3)
            , fontFamilies [ fontLight ]
            ]
        ]
