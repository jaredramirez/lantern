module Pages.Utils exposing (PageLoadError, pageLoadError, Field, initField, isNothing, validateOne)

-- PAGES


type PageLoadError
    = PageLoadError String


pageLoadError : String -> PageLoadError
pageLoadError errorMsg =
    PageLoadError errorMsg



-- FORMS


type alias Field =
    { value : String
    , error : Maybe String
    }


initField : Field
initField =
    Field "" Nothing


isNothing : Maybe val -> Bool
isNothing maybe =
    if maybe == Nothing then
        True
    else
        False


validateOne : String -> Maybe String
validateOne value =
    let
        errorMessage =
            "Required"
    in
        if value == "" then
            Just errorMessage
        else
            Nothing
