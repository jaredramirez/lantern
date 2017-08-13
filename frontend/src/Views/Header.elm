module Views.Header exposing (view, viewOnlyTop)

import Html exposing (Html, div, span, a, text)
import Route exposing (Route(..), href)
import Styles.Misc exposing (getClass)
import Styles.Header as HeaderStyles
import Styles.SubHeader as SubHeaderStyles


headerClass =
    getClass HeaderStyles.namespace


viewHeader : Html msg
viewHeader =
    div [ headerClass [ HeaderStyles.Bar ] ]
        [ span [ headerClass [ HeaderStyles.Title ] ] [ text "LANTERN" ]
        , span [ headerClass [ HeaderStyles.SubTitle ] ] [ text "AN ARBITRARILY NAMED BLOG" ]
        ]


subHeaderClass =
    getClass SubHeaderStyles.namespace


viewSubHeader : Html msg
viewSubHeader =
    div [ subHeaderClass [ SubHeaderStyles.Container ] ]
        [ a [ subHeaderClass [ SubHeaderStyles.Section ], href Posts ]
            [ span
                [ subHeaderClass [ SubHeaderStyles.Text ] ]
                [ text "POSTS" ]
            ]
        , a [ subHeaderClass [ SubHeaderStyles.Section ], href Login ]
            [ span
                [ subHeaderClass [ SubHeaderStyles.Text ] ]
                [ text "ACCOUNT" ]
            ]
        ]


viewOnlyTop : Html msg -> Html msg
viewOnlyTop page =
    div []
        [ viewHeader
        , page
        ]


view : Html msg -> Html msg
view page =
    div []
        [ viewHeader
        , viewSubHeader
        , page
        ]
