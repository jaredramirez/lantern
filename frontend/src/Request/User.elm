module Request.User exposing (userObject)

import GraphQL.Request.Builder exposing (..)
import Data.User exposing (User)


userObject : ValueSpec NonNull ObjectType User vars
userObject =
    object User
        |> with (field "id" [] string)
        |> with (field "firstName" [] string)
        |> with (field "lastName" [] string)
        |> with (field "email" [] string)
