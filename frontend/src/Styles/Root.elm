port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Css exposing (Stylesheet)
import Html.CssHelpers exposing (Namespace)
import Styles.Header
import Styles.List
import Styles.Page


port files : CssFileStructure -> Cmd msg


generateFile :
    ( Namespace String class id msg, Stylesheet )
    -> ( String, { css : String, warnings : List String } )
generateFile ( namespace, css ) =
    let
        fileExtension =
            ".css"
    in
        ( String.append namespace.name fileExtension
        , Css.File.compile [ css ]
        )


fileStructure : CssFileStructure
fileStructure =
    let
        files =
            [ ( Styles.Header.namespace, Styles.Header.css )
            , ( Styles.List.namespace, Styles.List.css )
            , ( Styles.Page.namespace, Styles.Page.css )
            ]
    in
        Css.File.toFileStructure (List.map generateFile files)


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
