module Data.Auth exposing (AuthPayload, LoginVars)

import Data.User exposing (User)


type alias AuthPayload =
    { token : String
    , user : User
    }


type alias LoginVars =
    { user :
        { email : String
        , password : String
        }
    }
