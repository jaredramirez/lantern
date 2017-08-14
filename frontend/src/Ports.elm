port module Ports exposing (..)

import Json.Encode exposing (Value)


port saveSession : Maybe String -> Cmd msg


port onSessionChange : (Value -> msg) -> Sub msg
