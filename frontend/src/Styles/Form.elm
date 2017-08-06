module Styles.Form exposing (Classes(..), namespace, css)

import Css exposing (..)
import Html.CssHelpers exposing (withNamespace)
import Css.Namespace
import Constants exposing (fontLight, fontBold, colors)


type Classes
    = Input
    | InputTextField
    | InputTextArea
    | Button


namespace =
    withNamespace "form"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Input
            [ borderStyle solid
            , borderColor (hex colors.slate)
            , borderWidth (vh 0.5)
            , fontFamilies [ fontLight ]
            , paddingTop (vh 2)
            , paddingBottom (vh 2)
            , paddingLeft (vw 2)
            , paddingRight (vw 2)
            , focus
                [ borderColor (hex colors.tomato)
                , outline none
                ]
            ]
        , class InputTextField
            [ fontSize (vh 2)
            , height (vw 2)
            , width (vw 30)
            ]
        , class InputTextArea
            [ fontSize (vh 2)
            , height (vw 15)
            , width (vw 70)
            ]
        , class Button
            [ displayFlex
            , alignItems center
            , justifyContent center
            , height (vh 5)
            , fontFamilies [ fontBold ]
            , fontSize (vw 2)
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
