module Pages.SignUp exposing (view)

import Html exposing (Html, div, span, text)


view : Html msg
view =
    div [] [ span [] [ text "SignUp" ] ]



-- module Pages.SignUp exposing (Model, init, view, Msg, update)
-- import Html exposing (Html, div)
-- type alias Model =
-- { email : String
-- , firstName : String
-- , lastName : String
-- , isCreating : Bool
-- }
-- init : Model
-- init =
-- { email = ""
-- , firstName = ""
-- , lastName = ""
-- , isCreating = False
-- }
-- view : Model -> Html Msg
-- view model =
-- div [] []
-- type Msg
-- = CreateUser
-- | CreateUserSuccess
-- update : Msg -> Model -> ( Model, Cmd Msg )
-- update msg model =
-- case msg of
-- -- TODO: Add call to create user
-- CreateUser ->
-- ( { model | isCreating = True }, Cmd.none )
-- CreateUserSuccess ->
-- ( model, Cmd.none )
