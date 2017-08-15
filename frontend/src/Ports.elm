port module Ports exposing (..)

import Json.Encode exposing (Value)
import Data.Session exposing (Session)


port saveSession : Session -> Cmd msg


port resetSession : () -> Cmd msg


port onSessionChange : (Value -> msg) -> Sub msg
