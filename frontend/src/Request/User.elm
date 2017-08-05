module Request.User exposing (userObject)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl)
import Data.Auth exposing (AuthPayload, LoginVars)
import Data.User exposing (User)


userObject : ValueSpec NonNull ObjectType User vars
userObject =
    object User
        |> with (field "id" [] string)
        |> with (field "firstName" [] string)
        |> with (field "lastName" [] string)
        |> with (field "email" [] string)


authObject : ValueSpec NonNull ObjectType AuthPayload var
authObject =
    object AuthPayload
        |> with (field "token" [] string)
        |> with (field "user" [] userObject)


type alias AuthenticateUserResponse =
    Result GraphQLClient.Error



-- authenticateQuery : Document Query AuthPayload LoginVars
-- authenticateQuery =
-- let
-- email =
-- Var.required "email" .email Var.string
-- password =
-- Var.required "password" .password Var.string
-- user =
-- Var.required "user" .user Var.object
-- in
-- extract
-- (field "authenticate"
-- [ ( "user", Arg.variable user ) ]
-- (extract (field "token" [] string))
-- )
