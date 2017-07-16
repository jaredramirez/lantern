port module Stylesheets exposing (..)

import Css.File exposing (CssFileStructure, CssCompilerProgram)
import Css exposing (Stylesheet)
import Html.CssHelpers exposing (Namespace)


-- Pages

import Styles.Page
import Styles.Landing


-- Views

import Styles.List
import Styles.Post
import Styles.Header
import Styles.SubHeader
import Styles.ContentHeader


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
            [ ( Styles.Page.namespace, Styles.Page.css )
            , ( Styles.Landing.namespace, Styles.Landing.css )
            , ( Styles.List.namespace, Styles.List.css )
            , ( Styles.Post.namespace, Styles.Post.css )
            , ( Styles.Header.namespace, Styles.Header.css )
            , ( Styles.SubHeader.namespace, Styles.SubHeader.css )
            , ( Styles.ContentHeader.namespace, Styles.ContentHeader.css )
            ]
    in
        Css.File.toFileStructure (List.map generateFile files)


main : CssCompilerProgram
main =
    Css.File.compiler files fileStructure
