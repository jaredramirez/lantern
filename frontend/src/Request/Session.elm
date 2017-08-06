module Request.Session exposing (AuthenticateResponse, sendAuthenticateRequest)

import Task exposing (Task)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl)
import Request.User exposing (userObject)
import Data.Session exposing (Session, AuthenticateVars)


sessionObject : ValueSpec NonNull ObjectType Session var
sessionObject =
    object Session
        |> with (field "token" [] string)
        |> with (field "user" [] userObject)


loginObject : ( String, Arg.Value AuthenticateVars )
loginObject =
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



-- authenticate a user


type alias AuthenticateResponse =
    Result GraphQLClient.Error Session


authenticateMutation : Document Mutation Session AuthenticateVars
authenticateMutation =
    mutationDocument <|
        extract (field "authenticate" [ loginObject ] sessionObject)


authenticateRequest : AuthenticateVars -> Request Mutation Session
authenticateRequest authenticateVars =
    authenticateMutation |> request authenticateVars


sendAuthenticateRequest : AuthenticateVars -> Task GraphQLClient.Error Session
sendAuthenticateRequest authenticateVars =
    GraphQLClient.sendMutation serverUrl (authenticateRequest authenticateVars)
