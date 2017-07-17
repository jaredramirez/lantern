module Pages.Post exposing (Model, init, view)

import Html exposing (Html, div, span, text)
import Task exposing (Task)
import Data.Request exposing (postsRequest)
import Data.Post exposing (Post)


type alias Model =
    { post : Post
    , isFetching : Bool
    , fetchError : String
    }


initPost : Post
initPost =
    { id = ""
    , title = ""
    , body = ""
    , stars = []
    , author =
        { id = ""
        , firstName = ""
        , lastName = ""
        , email = ""
        }
    }


initModel : Model
initModel =
    { post = initPost
    , isFetching = True
    , fetchError = ""
    }


init : ( Model, Task Model Model )
init =
    let
        handleSuccess : Post -> Model
        handleSuccess post =
            Model post False ""

        handleError : GraphQLClient.Error -> Model
        handleError _ =
            Model initPost False ""
    in
        ( initModel
        , Task.map handleSuccess postsRequest
            |> Task.mapError handleError
        )


view : Model -> Html msg
view =
    div []
        [ span [] [ text "post" ]
        ]
