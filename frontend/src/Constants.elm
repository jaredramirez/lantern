module Constants exposing (serverUrl, fontLight, fontBold, colors)


serverUrl : String
serverUrl =
    "http://localhost:3000/graphql"


fontLight : String
fontLight =
    "Moon-Light"


fontBold : String
fontBold =
    "Moon-Bold"


type alias Colors =
    { tomato : String
    , slate : String
    , babyPowder : String
    , cerulean : String
    }


colors : Colors
colors =
    { tomato = "FE5D4C"
    , slate = "374F4C"
    , babyPowder = "FFFEFC"
    , cerulean = "007AA3"
    }
