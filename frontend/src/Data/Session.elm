module Data.Session exposing (Session, AuthenticateVars)

import Data.User exposing (User)


type alias Session =
    { token : String
    , user : User
    }


type alias AuthenticateVars =
    { email : String
    , password : String
    }
