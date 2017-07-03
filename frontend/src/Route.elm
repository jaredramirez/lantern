module Route exposing (Route(..), href, fromLocation)

import Html exposing (Attribute)
import Html.Attributes as HtmlAttr
import Navigation
import UrlParser exposing (Parser, oneOf, s, parseHash)


-- EXTERNAL


type Route
    = NotFound
    | Landing


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
        , UrlParser.map NotFound (s "*")
        ]


routeToString : Route -> String
routeToString route =
    let
        routeParts =
            case route of
                Landing ->
                    [ "" ]

                _ ->
                    []
    in
        "/#/" ++ String.join "/" routeParts
