module Constants exposing (serverUrl, serverRequestOptions, fontLight, fontBold, colors)

import Http exposing (header)
import GraphQL.Client.Http exposing (RequestOptions)


serverUrl : String
serverUrl =
    "http://localhost:3000/graphql"


serverRequestOptions : String -> String -> RequestOptions
serverRequestOptions method token =
    { method = method
    , headers = [ header "Authorization" ("Bearer " ++ token) ]
    , url = serverUrl
    , timeout = Nothing
    , withCredentials = False
    }


fontLight : String
fontLight =
    "Gilroy-Light"


fontBold : String
fontBold =
    "Gilroy-Bold"


type alias Colors =
    { tomato : String
    , slate : String
    , babyPowder : String
    , cerulean : String
    }


colors : Colors
colors =
    { tomato = "FE5D4C"
    , slate = "374F4C"
    , babyPowder = "FFFEFC"
    , cerulean = "007AA3"
    }
