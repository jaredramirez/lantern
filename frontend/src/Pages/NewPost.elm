module Pages.NewPost exposing (Model, init, view, Msg, update)

import Html exposing (Html, div)
import Navigation


type alias Model =
    { title : String
    , body : String
    , isCreating : Bool
    }


init : Model
init =
    { title = ""
    , body = ""
    , isCreating = False
    }


view : Model -> Html Msg
view model =
    div [] []


type Msg
    = CreatePost
    | CreatePostSuccess


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- TODO: Add call to create post
        CreatePost ->
            ( { model | isCreating = True }, Cmd.none )

        CreatePostSuccess ->
            ( model, Navigation.back 1 )
