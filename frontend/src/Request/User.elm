module Request.User
    exposing
        ( userObject
        , createUserArgObject
        , UserResponse
        , sendUpdateUserMutationRequest
        )

import Task exposing (Task)
import GraphQL.Request.Builder exposing (..)
import GraphQL.Request.Builder.Arg as Arg
import GraphQL.Request.Builder.Variable as Var
import GraphQL.Client.Http as GraphQLClient
import Constants exposing (serverUrl, serverRequestOptions)
import Data.User exposing (User, CreateUserVars, UpdateUserVars)
import Data.Session exposing (Session)


userObject : ValueSpec NonNull ObjectType User vars
userObject =
    object User
        |> with (field "id" [] string)
        |> with (field "firstName" [] string)
        |> with (field "lastName" [] string)
        |> with (field "email" [] string)


createUserArgObject : ( String, Arg.Value CreateUserVars )
createUserArgObject =
    let
        firstName =
            Var.required "firstName" .firstName Var.string

        lastName =
            Var.required "lastName" .lastName Var.string

        email =
            Var.required "email" .email Var.string

        password =
            Var.required "password" .password Var.string
    in
        ( "user"
        , Arg.object
            [ ( "firstName", Arg.variable firstName )
            , ( "lastName", Arg.variable lastName )
            , ( "email", Arg.variable email )
            , ( "password", Arg.variable password )
            ]
        )


updateUserArgObject : ( String, Arg.Value UpdateUserVars )
updateUserArgObject =
    let
        firstName =
            Var.required "firstName" .firstName Var.string

        lastName =
            Var.required "lastName" .lastName Var.string

        email =
            Var.required "email" .email Var.string

        password =
            Var.required "password" .password Var.string
    in
        ( "user"
        , Arg.object
            [ ( "firstName", Arg.variable firstName )
            , ( "lastName", Arg.variable lastName )
            , ( "email", Arg.variable email )
            , ( "password", Arg.variable password )
            ]
        )



-- UPDATE


type alias UserResponse =
    Result GraphQLClient.Error User


updateUserMutation : Document Mutation User UpdateUserVars
updateUserMutation =
    let
        id =
            Var.required "id" .id Var.string
    in
        mutationDocument <|
            extract (field "updateUser" [ ( "id", Arg.variable id ), updateUserArgObject ] userObject)


updateUserMutationRequest : UpdateUserVars -> Request Mutation User
updateUserMutationRequest vars =
    updateUserMutation |> request vars


sendUpdateUserMutationRequest : UpdateUserVars -> Session -> Task GraphQLClient.Error User
sendUpdateUserMutationRequest vars { token } =
    GraphQLClient.customSendMutation
        (serverRequestOptions "POST" token)
        (updateUserMutationRequest vars)
