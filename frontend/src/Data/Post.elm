module Data.Post exposing (Post, NewPostVars, Posts, idParser, Id(Id), idToString)

import UrlParser exposing (Parser, custom)
import Data.User exposing (User)


type alias Post =
    { id : String
    , title : String
    , body : String
    , stars : List String
    , author : User
    }


type alias NewPostVars =
    { title : String
    , body : String
    }


type alias Posts =
    List Post


type Id
    = Id String


idParser : Parser (Id -> a) a
idParser =
    custom "ID" (Ok << Id)


idToString : Id -> String
idToString (Id id) =
    id
