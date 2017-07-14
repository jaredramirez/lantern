module Styles.ContentHeader exposing (Classes(..), namespace, css)

import Css exposing (..)
import Css.Namespace
import Html.CssHelpers exposing (withNamespace)
import Styles.Constants exposing (colors)


type Class
    = Container
    | Text


namespace =
    withNamespace "contentHeader"


css =
    (stylesheet << Css.Namespace.namespace namespace.name)
        [ class Container
            [ displayFlex
            ]
        ]
