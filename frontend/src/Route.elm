module Route exposing (Route(..), href, fromLocation, newUrl, modifyUrl)

import Html exposing (Html, Attribute)
import Html.Attributes as HtmlAttr
import Html.Events exposing (onClick)
import Navigation
import UrlParser exposing (Parser, map, oneOf, parseHash, s, (</>), custom, (<?>), stringParam)
import Data.Post as Post


-- EXTERNAL


type Route
    = NotFound
    | Landing
    | Posts
    | NewPost
    | Post Post.Id
    | Account
    | Login
    | SignUp


href : Route -> Attribute msg
href route =
    HtmlAttr.href (routeToString route)


fromLocation : Navigation.Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Landing
    else
        parseHash routeParser location


newUrl : Route -> Cmd msg
newUrl =
    Navigation.newUrl << routeToString


modifyUrl : Route -> Cmd msg
modifyUrl =
    Navigation.modifyUrl << routeToString



-- INTERNAL


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ map Landing (s "")
        , map Posts (s "posts")
        , map NewPost (s "posts" </> s "new")
        , map Post (s "posts" </> Post.idParser)
        , map Account (s "account")
        , map Login (s "login")
        , map SignUp (s "signup")
        , map NotFound (s "*")
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

                Account ->
                    [ "account" ]

                Login ->
                    [ "login" ]

                SignUp ->
                    [ "signup" ]

                _ ->
                    []
    in
        "/#/" ++ String.join "/" routeParts
