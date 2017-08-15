module Data.Session exposing (Session, decoder, AuthenticateVars)

import Json.Encode exposing (Value)
import Json.Decode exposing (Decoder, map2, field, maybe, string)
import Data.User as UserData


type alias Session =
    { token : String
    , user : UserData.User
    }


decoder : Decoder Session
decoder =
    map2 Session
        (field "token" string)
        (field "user" UserData.decoder)


type alias AuthenticateVars =
    { email : String
    , password : String
    }
