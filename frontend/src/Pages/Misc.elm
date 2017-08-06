module Pages.Misc exposing (Field, initField)

-- FORM HELPERS


type alias Field =
    { value : String
    , error : Maybe String
    }


initField : Field
initField =
    Field "" Nothing
