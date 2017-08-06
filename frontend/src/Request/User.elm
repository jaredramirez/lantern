module Request.User exposing (userObject)

import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl)
import Data.User exposing (User)


userObject : ValueSpec NonNull ObjectType User vars
userObject =
    object User
        |> with (field "id" [] string)
        |> with (field "firstName" [] string)
        |> with (field "lastName" [] string)
        |> with (field "email" [] string)
