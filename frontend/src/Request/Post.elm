module Request.Post exposing (postsRequest, PostsResponse)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Client.Http as GraphQLClient
import Request.User exposing (userObject)
import Data.Post exposing (Post, Posts)


type alias PostsResponse =
    Result GraphQLClient.Error Posts


postObject : ValueSpec NonNull ObjectType Post vars
postObject =
    object Post
        |> with (field "id" [] string)
        |> with (field "title" [] string)
        |> with (field "body" [] string)
        |> with (field "stars" [] (list string))
        |> with (field "author" [] userObject)


postsQuery : Document Query Posts vars
postsQuery =
    queryDocument
        (extract (field "posts" [] (list postObject)))


postsRequest : Request Query Posts
postsRequest =
    postsQuery |> request {}
