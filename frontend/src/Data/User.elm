module Data.User exposing (User, CreateUserVars, UpdateUserVars, decoder)

import Json.Decode exposing (Decoder, map4, field, string)


type alias User =
    { id : String
    , firstName : String
    , lastName : String
    , email : String
    }


type alias CreateUserVars =
    { firstName : String
    , lastName : String
    , email : String
    , password : String
    }


type alias UpdateUserVars =
    { id : String
    , firstName : String
    , lastName : String
    , email : String
    , password : String
    }


decoder : Decoder User
decoder =
    map4 User
        (field "id" string)
        (field "firstName" string)
        (field "lastName" string)
        (field "email" string)
