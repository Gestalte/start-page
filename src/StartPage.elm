module StartPage exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias LinkBlock = 
    { links : List (String, String)
    , title : String 
    }

general : LinkBlock
general =
    { links = 
        [ ("https://schedule.hololive.tv/lives", "Hololive")
        , ("https://www.youtube.com/", "Youtube")
        , ("https://cryptowat.ch/charts/LUNO:BTC-ZAR?period=1d", "Crypto Watch")
        , ("https://news.ycombinator.com/news", "Hacker News")
        , ("https://mail.google.com", "Gmail")
        , ("https://keep.google.com", "Keep")
        , ("https://calendar.google.com", "Calendar")
        ]
    , title = "General"
    }

programming : LinkBlock
programming =
    { links = 
        [ ("https://github.com/Gestalte", "Github")
        , ("https://app.pluralsight.com/profile", "Pluralsight")
        , ("https://portal.azure.com/#home", "Azure")
        , ("https://www.w3schools.com/default.asp", "W3 Schools")
        ]
    , title = "Programming"
    }

boards : LinkBlock
boards = 
    { links = 
        [ ("https://boards.4channel.org/vt/", "/vt/")
        , ("https://boards.4channel.org/vg/", "/vg/")
        , ("https://boards.4channel.org/vg/catalog#s=milsim", "/milsim/")
        , ("https://boards.4channel.org/out/", "/out/")
        ]
    , title = "Boards"
    }

translate : LinkBlock
translate = 
    { links = 
        [ ("https://www.deepl.com/translator#ja/en", "DeepL")
        , ("https://translate.google.com/?sl=ja&tl=en", "Google Translate")
        ]
    , title = "Translate"
    }

torrents : LinkBlock
torrents =
    { links = 
        [ ("https://nyaa.si", "Nyaa")
        , ("https://thepiratebay.org/index.html", "Piratebay")
        ]
    , title = "Torrents"
    }

makeLink : (String, String) -> List (Html msg)
makeLink (link, txt) =
    [ li []
        [ a [href link] [text txt]]
    ]

makeBlock : { a | title : String, links : List (String, String) } -> Html msg
makeBlock model =
    div [ class "outline" ] 
        [ h1 [] [text model.title]
        , ul [] (List.concat (List.map makeLink model.links))            
        ]

initialModel : { general : LinkBlock, programming : LinkBlock, boards : LinkBlock, translate : LinkBlock, torrents : LinkBlock }
initialModel =
    { general = general
    , programming = programming
    , boards = boards
    , translate = translate
    , torrents = torrents
    }

view model =
    div [class "bg"]
        [ div [ class "flex-container" ]
            [ makeBlock model.general
            , makeBlock model.programming
            , makeBlock model.boards
            , makeBlock model.translate
            , makeBlock model.torrents
            ]
        ]

main : Html msg
main = 
    view initialModel
