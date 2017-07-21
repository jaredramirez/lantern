module Data.Post exposing (Post, Posts, idParser, idToString, stringToId, Id(Id))

import UrlParser exposing (Parser, custom)
import Data.User exposing (User)


type alias Post =
    { id : String
    , title : String
    , body : String
    , stars : List String
    , author : User
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


stringToId : String -> Id
stringToId id =
    Id id
