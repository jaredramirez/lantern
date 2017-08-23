module Request.Session
    exposing
        ( AuthenticateResponse
        , sendAuthenticateRequest
        , sendCreateUserMutationRequest
        )

import Task exposing (Task)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl)
import Request.User exposing (userObject, createUserArgObject)
import Data.User exposing (CreateUserVars)
import Data.Session exposing (Session, AuthenticateVars)


loginArgObject : ( String, Arg.Value AuthenticateVars )
loginArgObject =
    let
        email =
            Var.required "email" .email Var.string

        password =
            Var.required "password" .password Var.string
    in
        ( "user"
        , Arg.object
            [ ( "email", Arg.variable email )
            , ( "password", Arg.variable password )
            ]
        )


sessionObject : ValueSpec NonNull ObjectType Session var
sessionObject =
    object Session
        |> with (field "token" [] string)
        |> with (field "user" [] userObject)


type alias AuthenticateResponse =
    Result GraphQLClient.Error Session



-- create a user


createUserMutation : Document Mutation Session CreateUserVars
createUserMutation =
    mutationDocument <|
        extract (field "createUser" [ createUserArgObject ] sessionObject)


createUserMutationRequest : CreateUserVars -> Request Mutation Session
createUserMutationRequest vars =
    createUserMutation |> request vars


sendCreateUserMutationRequest : CreateUserVars -> Task GraphQLClient.Error Session
sendCreateUserMutationRequest vars =
    GraphQLClient.sendMutation serverUrl (createUserMutationRequest vars)



-- authenticate a user


authenticateMutation : Document Mutation Session AuthenticateVars
authenticateMutation =
    mutationDocument <|
        extract (field "authenticate" [ loginArgObject ] sessionObject)


authenticateRequest : AuthenticateVars -> Request Mutation Session
authenticateRequest authenticateVars =
    authenticateMutation |> request authenticateVars


sendAuthenticateRequest : AuthenticateVars -> Task GraphQLClient.Error Session
sendAuthenticateRequest authenticateVars =
    GraphQLClient.sendMutation serverUrl (authenticateRequest authenticateVars)
