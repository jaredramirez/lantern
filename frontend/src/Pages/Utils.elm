module Pages.Utils exposing (PageLoadError, pageLoadError)


type PageLoadError
    = PageLoadError String


pageLoadError : String -> PageLoadError
pageLoadError errorMsg =
    PageLoadError errorMsg
