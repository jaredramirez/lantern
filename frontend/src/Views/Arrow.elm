module Views.Arrow exposing (view)

import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


view : Html msg
view =
    svg
        [ height "30", width "30", viewBox "0 0 24 24" ]
        [ Svg.path [ fill "none", d "M0 0h24v24H0z" ] []
        , Svg.path [ fill "#FE5D4C", d "M20 3H4v10c0 2.21 1.79 4 4 4h6c2.21 0 4-1.79 4-4v-3h2c1.11 0 2-.89 2-2V5c0-1.11-.89-2-2-2zm0 5h-2V5h2v3zM2 21h18v-2H2v2z" ] []
        ]
