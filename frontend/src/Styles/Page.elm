module Styles.Page exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Styles.Constants exposing (colors)


type Classes
    = Backdrop
    | Container
    | Text
    | Link


namespace =
    withNamespace "page"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Backdrop
            [ backgroundColor (hex colors.babyPowder)
            , height (vh 100)
            , width (vw 100)
            , displayFlex
            , flexDirection column
            , alignItems stretch
            ]
        , class Container
            [ displayFlex
            , alignItems center
            , justifyContent center
            ]
        , class Text
            [ fontSize (vh 3)
            , fontFamilies [ "Moon-Light" ]
            , color (hex colors.slate)
            ]
        , class Link
            [ textDecoration none
            ]
        ]
