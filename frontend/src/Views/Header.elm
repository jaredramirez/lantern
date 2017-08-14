module Views.Header exposing (view, viewMinimal)

import Html exposing (Html, div, span, a, text)
import Route exposing (Route(..), href)
import Data.Session exposing (Session)
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


viewLogout : Maybe Session -> Html msg
viewLogout maybeSession =
    if maybeSession /= Nothing then
        span [ headerClass [ HeaderStyles.Logout ] ] [ text "LOGOUT" ]
    else
        span [] []


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


viewMinimal : Maybe Session -> Html msg -> Html msg
viewMinimal maybeSession subview =
    div [] [ viewHeader, viewLogout maybeSession, subview ]


view : Maybe Session -> Html msg -> Html msg
view maybeSession page =
    div [] [ (viewMinimal maybeSession viewSubHeader), page ]
