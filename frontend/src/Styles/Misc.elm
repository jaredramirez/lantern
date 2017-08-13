module Styles.Misc exposing (getClass)

import Html exposing (Attribute)
import Html.CssHelpers exposing (Namespace)


getClass : Namespace name class id msg -> (List class -> Attribute msg)
getClass { class } =
    class
