module Styles.SubHeader exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (Namespace, withNamespace)
import Css.Namespace
import Styles.Constants exposing (colors)


type Classes
    = Container
    | Section
    | Text


namespace =
    withNamespace "subheader"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ backgroundColor (hex colors.cerulean)
            , displayFlex
            , alignItems center
            , justifyContent center
            , height (vh 5)
            ]
        , class Section
            [ flex (int 1)
            , displayFlex
            , alignItems center
            , justifyContent center
            , textDecoration none
            ]
        , class Text
            [ fontSize (vh 2.5)
            , fontFamilies [ "Moon-Light" ]
            , color (hex colors.babyPowder)
            , textDecoration none
            ]
        ]
