module Views.ContentHeader exposing (view, viewBack, viewNewPost)

import Html exposing (Html, Attribute, div, a, span, text)
import Html.Events exposing (onClick)
import Route exposing (Route, href)
import Styles.ContentHeader exposing (Classes(..), namespace)


{ class } =
    namespace


viewMaybe : Maybe (Html msg) -> Html msg
viewMaybe maybeView =
    case maybeView of
        Just view ->
            view

        Nothing ->
            div [] []


view : Maybe (Html msg) -> ( String, Maybe String ) -> Maybe (Html msg) -> Html msg
view maybeViewLeft ( title, maybeSubTitle ) maybeViewRight =
    div [ class [ Container ] ]
        [ div [ class [ Flex ] ] [ viewMaybe maybeViewLeft ]
        , div [ class [ MainContainer ] ]
            [ span [ class [ MainText ] ] [ text title ]
            , span [ class [ SubText ] ]
                [ text
                    (case maybeSubTitle of
                        Just subtitle ->
                            subtitle

                        Nothing ->
                            ""
                    )
                ]
            ]
        , div [ class [ Flex ] ] [ viewMaybe maybeViewRight ]
        ]


viewBack : msg -> Html msg
viewBack onClickMsg =
    div [ onClick onClickMsg, class [ Link ] ] [ text "back" ]


viewNewPost : Html msg
viewNewPost =
    div [ class [ Link ] ]
        [ a [ href Route.NewPost, class [ Link ] ] [ text "new post" ] ]
