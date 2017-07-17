module Request.Post exposing (postsRequest, PostsResponse, postRequest, PostResponse)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Request.User exposing (userObject)
import Data.Post exposing (Post, Posts)


postObject : ValueSpec NonNull ObjectType Post vars
postObject =
    object Post
        |> with (field "id" [] string)
        |> with (field "title" [] string)
        |> with (field "body" [] string)
        |> with (field "stars" [] (list string))
        |> with (field "author" [] userObject)



-- Fetch list of posts


type alias PostsResponse =
    Result GraphQLClient.Error Posts


postsQuery : Document Query Posts vars
postsQuery =
    queryDocument
        (extract (field "posts" [] (list postObject)))


postsRequest : Request Query Posts
postsRequest =
    postsQuery |> request {}



-- Fetch indiviaul post


type alias PostResponse =
    Result GraphQLClient.Error Post


postQuery : Document Query Post { postId : String }
postQuery =
    let
        postId =
            Var.required "postId" .postId Var.id
    in
        queryDocument
            (extract (field "post" [ ( "id", Arg.variable postId ) ] postObject))


postRequest : String -> Request Query Post
postRequest postId =
    postQuery |> request { postId = postId }
