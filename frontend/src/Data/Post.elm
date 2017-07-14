module Data.Post exposing (Post, Posts)


type alias Post =
    { id : String
    , title : String
    , body : String
    , stars : List String
    , author : String
    }


type alias Posts =
    List Post
