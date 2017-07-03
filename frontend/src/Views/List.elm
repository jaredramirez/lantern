module Views.List exposing (viewItems, viewLinks)

import Html exposing (Html, div, span, ul, a, text)
import Html.Attributes exposing (style, href)
import Css
import Styles.List exposing (Classes(..), namespace)


{ class } =
    namespace


styles =
    Css.asPairs >> style


viewItem : String -> Html msg
viewItem value =
    span [ class [ Item ] ] [ text value ]


viewLink : ( String, String ) -> Html msg
viewLink ( value, link ) =
    a [ class [ Item ], href link ] [ text value ]


view :
    String
    -> Float
    -> Bool
    -> List String
    -> List ( String, String )
    -> Html msg
view title width renderAsLinks items links =
    div [ class [ Container ] ]
        (List.concat
            [ [ span [ class [ Title ] ] [ text title ]
              , span [ class [ Line ], styles [ Css.width (Css.vw width) ] ] []
              ]
            , if renderAsLinks then
                (List.map viewLink links)
              else
                (List.map viewItem items)
            ]
        )


viewItems : String -> List String -> Float -> Html msg
viewItems title items width =
    view title width False items []


viewLinks : String -> List ( String, String ) -> Float -> Html msg
viewLinks title links width =
    view title width True [] links
