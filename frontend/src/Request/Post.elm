module Request.Post exposing (postsRequest, PostsResponse)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Data.Post exposing (Post, Posts)


type alias PostsResponse =
    Result GraphQLClient.Error Posts


postsQuery : Document Query Posts vars
postsQuery =
    let
        post =
            object Post
                |> with (field "id" [] string)
                |> with (field "title" [] string)
                |> with (field "body" [] string)
                |> with (field "stars" [] (list string))
                |> with (field "author" [] string)
    in
        queryDocument
            (extract (field "posts" [] (list post)))


postsRequest : Request Query Posts
postsRequest =
    postsQuery |> request {}
