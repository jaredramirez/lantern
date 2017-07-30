module Styles.ContentHeader exposing (Classes(..), namespace, css)

import Css exposing (..)
import Css.Namespace
import Html.CssHelpers exposing (withNamespace)
import Styles.Constants exposing (colors)


type Classes
    = Container
    | MainContainer
    | MainText
    | SubText
    | Link
    | Flex


namespace =
    withNamespace "contentHeader"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , alignItems center
            , justifyContent spaceAround
            , height (vh 10)
            , marginTop (vh 2)
            ]
        , class MainContainer
            [ displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , backgroundColor (hex colors.cerulean)
            , borderStyle solid
            , borderColor (hex colors.slate)
            , borderWidth (vh 0.5)
            , height (vh 9)
            , width (vw 50)
            ]
        , class MainText
            [ fontFamilies [ "Moon-Bold" ]
            , fontSize (vh 3)
            , color (hex colors.babyPowder)
            ]
        , class SubText
            [ fontFamilies [ "Moon-Light" ]
            , fontSize (vh 2)
            , color (hex colors.babyPowder)
            , marginTop (vh 0.25)
            ]
        , class Link
            [ fontFamilies [ "Moon-Bold" ]
            , fontSize (vh 2.5)
            , textDecoration none
            , color (hex colors.tomato)
            , cursor pointer
            , textAlign center
            ]
        , class Flex
            [ flex (int 1) ]
        ]
