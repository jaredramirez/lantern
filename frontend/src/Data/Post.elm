module Data.Post exposing (Post, Posts)

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
