module Route exposing (Route(..), href, fromLocation)

import Html exposing (Html, Attribute)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Navigation
import UrlParser exposing (Parser, oneOf, parseHash, s, (</>))
import Data.Post as Post


-- EXTERNAL


type Route
    = NotFound
    | Landing
    | Posts
    | Post Post.Id
    | NewPost


href : Route -> Attribute msg
href route =
    HtmlAttr.href (routeToString route)


fromLocation : Navigation.Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Landing
    else
        parseHash routeParser location



-- INTERNAL


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ UrlParser.map Landing (s "")
        , UrlParser.map Posts (s "posts")
        , UrlParser.map NewPost (s "posts" </> s "new")
        , UrlParser.map Post (s "posts" </> Post.idParser)
        , UrlParser.map NotFound (s "*")
        ]


routeToString : Route -> String
routeToString route =
    let
        routeParts =
            case route of
                Landing ->
                    [ "" ]

                Posts ->
                    [ "posts" ]

                NewPost ->
                    [ "posts", "new" ]

                Post id ->
                    [ "posts", Post.idToString id ]

                _ ->
                    []
    in
        "/#/" ++ String.join "/" routeParts
