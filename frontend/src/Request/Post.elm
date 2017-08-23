module Request.Post
    exposing
        ( sendPostsRequest
        , PostsResponse
        , sendPostRequest
        , PostResponse
        , sendPostMutationRequest
        )

import Task exposing (Task)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl, serverRequestOptions)
import Request.User exposing (userObject)
import Data.Session exposing (Session)
import Data.Post exposing (Post, NewPostVars, Posts, Id, idToString)


newPostArgObject : ( String, Arg.Value NewPostVars )
newPostArgObject =
    let
        title =
            Var.required "title" .title Var.string

        body =
            Var.required "body" .body Var.string
    in
        ( "post"
        , Arg.object
            [ ( "title", Arg.variable title )
            , ( "body", Arg.variable body )
            ]
        )


postObject : ValueSpec NonNull ObjectType Post vars
postObject =
    object Post
        |> with (field "id" [] string)
        |> with (field "title" [] string)
        |> with (field "body" [] string)
        |> with (field "stars" [] (list string))
        |> with (field "author" [] userObject)


type alias PostsResponse =
    Result GraphQLClient.Error Posts



-- Fetch list of posts


postsQuery : Document Query Posts vars
postsQuery =
    queryDocument
        (extract (field "posts" [] (list postObject)))


postsRequest : Request Query Posts
postsRequest =
    postsQuery |> request {}


sendPostsRequest : Task GraphQLClient.Error Posts
sendPostsRequest =
    GraphQLClient.sendQuery serverUrl postsRequest


type alias PostResponse =
    Result GraphQLClient.Error Post



-- Get post


postQuery : Document Query Post { postId : String }
postQuery =
    let
        postId =
            Var.required "postId" .postId Var.string
    in
        queryDocument
            (extract (field "post" [ ( "id", Arg.variable postId ) ] postObject))


postRequest : Id -> Request Query Post
postRequest postId =
    postQuery |> request { postId = (idToString postId) }


sendPostRequest : Id -> Task GraphQLClient.Error Post
sendPostRequest id =
    GraphQLClient.sendQuery serverUrl (postRequest id)



-- Create new post


postMutation : Document Mutation Post NewPostVars
postMutation =
    mutationDocument
        (extract (field "createPost" [ newPostArgObject ] postObject))


postMutationRequest : NewPostVars -> Request Mutation Post
postMutationRequest newPostVars =
    postMutation |> request newPostVars


sendPostMutationRequest : NewPostVars -> Session -> Task GraphQLClient.Error Post
sendPostMutationRequest newPostVars { token } =
    GraphQLClient.customSendMutation
        (serverRequestOptions "POST" token)
        (postMutationRequest newPostVars)
