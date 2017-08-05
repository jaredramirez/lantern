module Data.Misc exposing (WebData)

import GraphQL.Client.Http as GraphQLClient
import RemoteData exposing (RemoteData)


type alias WebData a =
    RemoteData GraphQLClient.Error a
