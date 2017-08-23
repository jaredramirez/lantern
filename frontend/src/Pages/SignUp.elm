module Pages.SignUp exposing (Model, init, view, Msg, ExternalMsg(..), update)

import Task exposing (Task)
import Html exposing (Html, div, span, text)
import Html.Attributes
import Css
import Navigation
import GraphQL.Client.Http exposing (Error)
import Validate exposing (ifBlank, ifInvalidEmail)
import RemoteData exposing (RemoteData(..))
import Route exposing (Route, newUrl)
import Request.Session exposing (AuthenticateResponse, sendCreateUserMutationRequest)
import Data.Session exposing (Session)
import Data.User exposing (CreateUserVars)
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
    , createRequest : WebData Session
    }


init : Model
init =
    Model initField initField initField initField False NotAsked


view : Model -> Html Msg
view { firstName, lastName, email, password, showPassword, createRequest } =
    div [ style stylesheet.container ]
        [ span [ style stylesheet.label ] [ text "SIGN UP" ]
        , viewTextField ( firstName.value, "first name", False ) SetFirstName
        , viewTextField ( lastName.value, "last name", False ) SetLastName
        , viewTextField ( email.value, "email", False ) SetEmail
        , div [ style stylesheet.buttonContainer ]
            [ viewTextField
                ( password.value, "password", not showPassword )
                SetPassword
            , div [ style stylesheet.button ] [ viewButton "show" TogglePasswordVisible ]
            ]
        , case createRequest of
            NotAsked ->
                viewButton "SIGN UP" BeginCreateIfValid

            Loading ->
                viewButton "LOADING..." BeginCreateIfValid

            Success _ ->
                div [] []

            Failure _ ->
                div []
                    [ viewButton "SIGN UP" BeginCreateIfValid
                    , span [] [ text "Failed to sign up." ]
                    ]
        ]


type ExternalMsg
    = SetSession Session
    | NoOp


type Msg
    = SetFirstName String
    | SetLastName String
    | SetEmail String
    | SetPassword String
    | TogglePasswordVisible
    | BeginCreateIfValid
    | CreateSuccess Session
    | CreateError Error


update : Msg -> Model -> ( ( Model, Cmd Msg ), ExternalMsg )
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
                    ( ( { model | firstName = Field firstNameValue maybeError }, Cmd.none ), NoOp )

            SetLastName lastNameValue ->
                let
                    maybeError =
                        List.head (nameValidator lastNameValue)
                in
                    ( ( { model | lastName = Field lastNameValue maybeError }, Cmd.none ), NoOp )

            SetEmail emailValue ->
                let
                    maybeError =
                        List.head (emailValidator emailValue)
                in
                    ( ( { model | email = Field emailValue maybeError }, Cmd.none ), NoOp )

            SetPassword passwordValue ->
                let
                    maybeError =
                        List.head (passwordValidator passwordValue)
                in
                    ( ( { model | password = Field passwordValue maybeError }, Cmd.none ), NoOp )

            TogglePasswordVisible ->
                ( ( { model | showPassword = not model.showPassword }, Cmd.none ), NoOp )

            BeginCreateIfValid ->
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
                    case maybeErrors of
                        ( Nothing, Nothing, Nothing, Nothing ) ->
                            ( ( { model | createRequest = Loading }
                              , createRequest
                                    { firstName = firstNameValue
                                    , lastName = lastNameValue
                                    , email = emailValue
                                    , password = passwordValue
                                    }
                              )
                            , NoOp
                            )

                        ( maybeFirstNameError, maybeLastNameError, maybeEmailError, maybePasswordError ) ->
                            ( ( { model
                                    | firstName = Field firstNameValue maybeFirstNameError
                                    , lastName = Field lastNameValue maybeLastNameError
                                    , email = Field emailValue maybeEmailError
                                    , password = Field passwordValue maybePasswordError
                                }
                              , Cmd.none
                              )
                            , NoOp
                            )

            CreateSuccess session ->
                ( ( { model | createRequest = Success session }
                  , newUrl Route.Posts
                  )
                , SetSession session
                )

            CreateError error ->
                ( ( { model | createRequest = Failure error }, Cmd.none ), NoOp )


createRequest : CreateUserVars -> Cmd Msg
createRequest vars =
    let
        handleResponse : AuthenticateResponse -> Msg
        handleResponse response =
            case response of
                Ok session ->
                    CreateSuccess session

                Err error ->
                    CreateError error
    in
        Task.attempt handleResponse (sendCreateUserMutationRequest vars)



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
