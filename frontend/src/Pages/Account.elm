module Pages.Account exposing (Model, init, view, Msg, update)

import Task exposing (Task)
import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import Navigation
import GraphQL.Client.Http exposing (Error)
import Validate exposing (ifBlank, ifInvalidEmail)
import RemoteData exposing (RemoteData(..))
import Request.User exposing (UserResponse, sendUpdateUserMutationRequest)
import Data.User exposing (UpdateUserVars)
import Data.Session exposing (Session)
import Data.Misc exposing (WebData)
import Pages.Misc exposing (Field, initField)
import Constants exposing (fontBold, colors)
import Views.Form exposing (viewTextField, viewButton)


type alias Model =
    { firstName : Field
    , lastName : Field
    , email : Field
    , password : Field
    , showPassword : Bool
    , updateRequest : WebData (Maybe String)
    }


init : Model
init =
    Model initField initField initField initField False NotAsked


view : Model -> Maybe Session -> Html Msg
view { firstName, lastName, email, password, showPassword, updateRequest } session =
    div [ style stylesheet.container ]
        [ span [ style stylesheet.label ] [ text "ACCOUNT" ]
        , viewTextField ( firstName.value, "firstName", False ) SetFirstName
        , viewTextField ( lastName.value, "last name", False ) SetLastName
        , viewTextField ( email.value, "email", False ) SetEmail
        , div [ style stylesheet.buttonContainer ]
            [ viewTextField
                ( password.value, "password", not showPassword )
                SetPassword
            , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
            ]
        , case updateRequest of
            NotAsked ->
                viewButton "UPDATE" (BeginUpdateIfValid session)

            Loading ->
                viewButton "LOADING..." (BeginUpdateIfValid session)

            Success _ ->
                div []
                    [ viewButton "UPDATE" (BeginUpdateIfValid session)
                    , span [] [ text "Success!" ]
                    ]

            Failure _ ->
                div []
                    [ viewButton "UPDATE" (BeginUpdateIfValid session)
                    , span [] [ text "Failed to update." ]
                    ]
        ]


type Msg
    = SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPassword String
    | TogglePasswordVisible
    | BeginUpdateIfValid (Maybe Session)
    | UpdateSuccess (Maybe String)
    | UpdateError Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        nameValidator =
            ifBlank "Name is required."

        emailValidator =
            ifInvalidEmail "Must be valid email"

        passwordValidator =
            ifBlank "Password is required"
    in
        case msg of
            SetFirstName firstNameValue ->
                let
                    maybeError =
                        List.head (nameValidator firstNameValue)
                in
                    ( { model | firstName = Field firstNameValue maybeError }, Cmd.none )

            SetLastName lastNameValue ->
                let
                    maybeError =
                        List.head (nameValidator lastNameValue)
                in
                    ( { model | lastName = Field lastNameValue maybeError }, Cmd.none )

            SetEmail emailValue ->
                let
                    maybeError =
                        List.head (emailValidator emailValue)
                in
                    ( { model | email = Field emailValue maybeError }, Cmd.none )

            SetPassword passwordValue ->
                let
                    maybeError =
                        List.head (passwordValidator passwordValue)
                in
                    ( { model | password = Field passwordValue maybeError }, Cmd.none )

            TogglePasswordVisible ->
                ( { model | showPassword = not model.showPassword }, Cmd.none )

            BeginUpdateIfValid maybeSession ->
                let
                    firstNameValue =
                        model.firstName.value

                    lastNameValue =
                        model.lastName.value

                    emailValue =
                        model.email.value

                    passwordValue =
                        model.password.value

                    maybeErrors =
                        ( List.head (nameValidator firstNameValue)
                        , List.head (nameValidator lastNameValue)
                        , List.head (emailValidator emailValue)
                        , List.head (passwordValidator passwordValue)
                        )
                in
                    case ( maybeErrors, maybeSession ) of
                        ( ( Nothing, Nothing, Nothing, Nothing ), Just session ) ->
                            ( { model | updateRequest = Loading }
                            , updateRequest
                                { id = session.user.id
                                , firstName = firstNameValue
                                , lastName = lastNameValue
                                , email = emailValue
                                , password = passwordValue
                                }
                                session
                            )

                        ( ( maybeFirstNameError, maybeLastNameError, maybeEmailError, maybePasswordError ), _ ) ->
                            ( { model
                                | firstName = Field firstNameValue maybeFirstNameError
                                , lastName = Field lastNameValue maybeLastNameError
                                , email = Field emailValue maybeEmailError
                                , password = Field passwordValue maybePasswordError
                              }
                            , Cmd.none
                            )

            UpdateSuccess maybe ->
                ( { model | updateRequest = Success maybe }
                , Cmd.none
                )

            UpdateError error ->
                ( { model | updateRequest = Failure error }, Cmd.none )


updateRequest : UpdateUserVars -> Session -> Cmd Msg
updateRequest vars session =
    let
        handleResponse : UserResponse -> Msg
        handleResponse response =
            case response of
                Ok session ->
                    UpdateSuccess Nothing

                Err error ->
                    UpdateError error
    in
        Task.attempt handleResponse (sendUpdateUserMutationRequest vars session)



-- STYLES


style =
    Css.asPairs >> Html.Attributes.style


stylesheet =
    { container =
        [ Css.displayFlex
        , Css.flexDirection Css.column
        , Css.alignItems Css.center
        , Css.justifyContent Css.spaceAround
        , Css.height (Css.vh 70)
        ]
    , label =
        [ Css.fontFamilies [ fontBold ]
        , Css.fontSize (Css.vw 2)
        , Css.color (Css.hex colors.tomato)
        ]
    , buttonContainer =
        [ Css.displayFlex
        , Css.flexDirection Css.row
        , Css.alignItems Css.center
        , Css.justifyContent Css.center
        ]
    , button =
        [ Css.position Css.absolute
        , Css.marginLeft (Css.pct 25)
        ]
    }
