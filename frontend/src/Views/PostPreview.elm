module Views.PostPreview exposing (view)

import Html exposing (Html, div, span, text)
import Styles.PostPreview exposing (Classes(..), namespace)
import Data.Post exposing (Post)


{ class } =
    namespace


view : Post -> Html msg
view post =
    div [ class [ Container ] ]
        [ div [ class [ Header ] ]
            [ span [ class [ Title ] ] [ text post.title ]
            , span [ class [ Author ] ] [ text (post.author.firstName ++ " " ++ post.author.lastName) ]
            ]
        , div [ class [ Body ] ]
            [ div [ class [ BodyText ] ] [ text post.body ]
            , div [ class [ Link ] ] [ text "See Full Post" ]
            ]
        ]
