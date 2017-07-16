module Styles.ContentHeader exposing (Classes(..), namespace, css)

import Css exposing (..)
import Css.Namespace
import Html.CssHelpers exposing (withNamespace)
import Styles.Constants exposing (colors)


type Classes
    = Container
    | MainText
    | SubText


namespace =
    withNamespace "contentHeader"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , alignItems flexEnd
            , justifyContent spaceAround
            , height (vh 8)
            ]
        , class MainText
            [ fontFamilies [ "Moon-Bold" ]
            , fontSize (vh 4)
            , color (hex colors.tomato)
            , textAlign center
            , flex (int 2)
            ]
        , class SubText
            [ fontFamilies [ "Moon-Bold" ]
            , fontSize (vh 3)
            , color (hex colors.tomato)
            , textAlign center
            , flex (int 1)
            ]
        ]
