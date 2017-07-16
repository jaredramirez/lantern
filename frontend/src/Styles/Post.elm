module Styles.Post exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Styles.Constants exposing (colors)


type Classes
    = Container
    | Header
    | Title
    | Author
    | Body
    | BodyText
    | Link


namespace =
    withNamespace "post"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , flexDirection column
            , alignItems stretch
            , justifyContent flexStart
            , borderStyle solid
            , borderColor (hex colors.slate)
            , borderWidth (vh 0.5)
            , height (vh 35)
            , marginTop (vh 4)
            , marginBottom (vw 4)
            , marginRight (vw 3)
            , marginLeft (vw 3)
            ]
        , class Header
            [ flex (int 1)
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent center
            , backgroundColor (hex colors.cerulean)
            ]
        , class Title
            [ fontSize (vh 3)
            , fontFamilies [ "Moon-Bold" ]
            , color (hex colors.babyPowder)
            ]
        , class Author
            [ marginTop (vh 1)
            , fontSize (vh 2)
            , fontFamilies [ "Moon-Light" ]
            , color (hex colors.babyPowder)
            ]
        , class Body
            [ flex (int 2)
            , displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent spaceAround
            , marginLeft (vw 2)
            , marginRight (vw 2)
            ]
        , class BodyText
            [ fontSize (vh 2)
            , fontFamilies [ "Moon-Light" ]
            , color (hex colors.slate)
            ]
        , class Link
            [ fontSize (vh 2)
            , fontFamilies [ "Moon-Light" ]
            , color (hex colors.tomato)
            ]
        ]
