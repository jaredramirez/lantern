module Views.Header exposing (view, viewMinimal)

import Html exposing (Html, div, span, a, text)
import Html.Events exposing (onClick)
import Route exposing (Route(..), href)
import Data.Session exposing (Session)
import Styles.Misc exposing (getClass)
import Styles.Header as HeaderStyles
import Styles.SubHeader as SubHeaderStyles


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


headerClass =
    getClass HeaderStyles.namespace


viewHeader : Html msg
viewHeader =
    div [ headerClass [ HeaderStyles.Bar ] ]
        [ span [ headerClass [ HeaderStyles.Title ] ] [ text "LANTERN" ]
        , span [ headerClass [ HeaderStyles.SubTitle ] ] [ text "AN ARBITRARILY NAMED BLOG" ]
        ]


type alias SessionData msg =
    ( Maybe Session, msg )


viewLogout : SessionData msg -> Html msg
viewLogout ( maybeSession, logoutMsg ) =
    if maybeSession /= Nothing then
        span
            [ headerClass [ HeaderStyles.Logout ], onClick logoutMsg ]
            [ text "LOGOUT" ]
    else
        span [] []


viewMinimal : SessionData msg -> Html msg -> Html msg
viewMinimal sessionData subview =
    div [] [ viewHeader, viewLogout sessionData, subview ]


view : SessionData msg -> Html msg -> Html msg
view sessionData page =
    div [] [ (viewMinimal sessionData viewSubHeader), page ]
