module Views.Form exposing (viewTextField, viewTextArea, viewButton)

import Html exposing (Html, input, textarea, button, text)
import Html.Attributes exposing (type_, placeholder, defaultValue)
import Html.Events exposing (onInput, onClick)
import Styles.Form exposing (Classes(..), namespace)


{ class } =
    namespace


viewTextField : ( String, String, Bool ) -> (String -> msg) -> Html msg
viewTextField ( defaultValue_, placeholder_, isPassword ) msg =
    input
        [ type_
            (if isPassword then
                "password"
             else
                "text"
            )
        , placeholder placeholder_
        , defaultValue defaultValue_
        , onInput msg
        , class [ Input, InputTextField ]
        ]
        []


viewTextArea : ( String, String ) -> (String -> msg) -> Html msg
viewTextArea ( defaultValue_, placeholder_ ) msg =
    textarea
        [ placeholder placeholder_
        , defaultValue defaultValue_
        , onInput msg
        , class [ Input, InputTextArea ]
        ]
        []


viewButton : String -> msg -> Html msg
viewButton label msg =
    button [ onClick msg, class [ Button ] ] [ text label ]
