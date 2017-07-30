module Styles.NewPost exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Styles.Constants exposing (colors)


type Classes
    = Container
    | Input
    | InputTitle
    | InputBody
    | Line
    | Button


namespace =
    withNamespace "newPost"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            , flexDirection column
            , alignItems center
            , justifyContent spaceAround
            , height (vh 65)
            ]
        , class Input
            [ borderStyle solid
            , borderColor (hex colors.slate)
            , borderWidth (vh 0.5)
            , fontFamilies [ "Moon-Light" ]
            , paddingTop (vh 2)
            , paddingBottom (vh 2)
            , paddingLeft (vw 2)
            , paddingRight (vw 2)
            , focus
                [ borderColor (hex colors.tomato)
                , outline none
                ]
            ]
        , class InputTitle
            [ fontSize (vh 2)
            , height (vw 2)
            , width (vw 30)
            ]
        , class InputBody
            [ fontSize (vh 2)
            , height (vw 15)
            , width (vw 70)
            ]
        , class Line
            [ height (vh 0.5)
            , width (vw 80)
            , backgroundColor (hex colors.cerulean)
            , margin (vh 1)
            , marginBottom (vh 2)
            ]
        , class Button
            [ displayFlex
            , alignItems center
            , justifyContent center
            , height (vh 5)
            , width (vw 30)
            , fontFamilies [ "Moon-Bold" ]
            , fontSize (vh 3.5)
            , borderStyle none
            , backgroundColor (hex colors.babyPowder)
            , color (hex colors.slate)
            , cursor pointer
            , focus [ outline none ]
            , active
                [ color (hex colors.tomato)
                , outline none
                ]
            ]
        ]
