module StartPage exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Task
import Time exposing (..)
import String exposing (length)

main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

type alias LinkBlock = 
    { linkColumns : List (List (String, String))
    , title : String 
    }

general : LinkBlock
general =
    { linkColumns = 
        [ [ ("https://schedule.hololive.tv/lives", "Hololive")
            , ("https://holodex.net/", "HoloDex")
            , ("https://music.holodex.net/", "MusicDex")
            , ("https://cryptowat.ch/charts/LUNO:BTC-ZAR?period=1d", "Crypto Watch")
            , ("https://mail.google.com", "Gmail")
            ]
        , [ ("https://www.youtube.com/", "Youtube")
            , ("https://twitch.tv/", "Twitch")            
            , ("https://calendar.google.com", "Calendar")
            , ("https://loot.co.za/", "Loot")
            , ("https://takealot.com/", "Takealot")
            ]
        ]
    , title = "General"
    }

programming : LinkBlock
programming =
    { linkColumns = 
        [   [ 
            ("https://github.com/Gestalte", "Github")
            , ("https://community.bistudio.com/wiki/Category:Arma_3:_Scripting_Commands","BIKI")
            , ("https://app.pluralsight.com/profile", "Pluralsight")
            , ("https://www.w3schools.com/default.asp", "W3 Schools")            
            ]
        ,   [("https://news.ycombinator.com/news", "Hacker News")
            , ("https://lobste.rs/", "lobste.rs")
            , ("https://portal.azure.com/#home", "Azure")
            , ("https://console.cloud.google.com","Google Cloud")
            ]
        ]
    , title = "Programming"
    }

boards : LinkBlock
boards = 
    { linkColumns = 
        [   [ ("https://boards.4channel.org/v/", "/v/")
            , ("https://boards.4channel.org/vt/", "/vt/")
            , ("https://boards.4channel.org/vg/", "/vg/")
            , ("https://boards.4channel.org/out/", "/out/")
            ]
        ,   [ ("https://boards.4channel.org/vg/catalog#s=milsim", "/milsim/")
            , ("https://boards.4channel.org/vg/catalog#s=agdg","/agdg/")
            , ("https://boards.4channel.org/vg/catalog#s=eftg","/eftg/")
            , ("https://lainchan.org/%CE%BB/catalog.html","/λ/")
            
            ]
        ]
    , title = "Boards"
    }

translate : LinkBlock
translate = 
    { linkColumns = 
        [[ ("https://www.deepl.com/translator#ja/en", "DeepL")
        , ("https://translate.google.com/?sl=ja&tl=en", "Google Translate")
        , ("https://conjugator.reverso.net/conjugation-japanese.html", "Reverso Conjugator")
        , ("https://jisho.org/", "Jisho Dictionary")
        ]]
    , title = "Translate"
    }

downloads : LinkBlock
downloads =
    { linkColumns =         
        [[("https://torrentfreak.com/","TorrentFreak")
        , ("https://thepiratebay.org/index.html", "Piratebay")
        , ("https://btdig.com/index.htm", "btdig")
        , ("https://nyaa.si", "Nyaa")
        ]
    ,   [("https://annas-archive.org/","Anna's Archive")
        , ("https://libgen.li/","libgen")
        , ("https://z-lib.is/","z-lib")
        ]]
    , title = "Downloads"
    }

makeLink : (String, String) -> List (Html msg)
makeLink (link, txt) =
    [ li []
        [ a [href link] [text txt]]
    ]

makeBlock : { a | title : String, linkColumns : List ( List (String, String)) } -> Html msg
makeBlock model =
    div [ class "outline" ] 
        [ h1 [] [text model.title]
        , div [ class "flex-container"]  
            (List.map (\ links -> makeColumn links) model.linkColumns )
        ]

makeColumn : List (String, String) -> Html msg
makeColumn links =
    div []
        [ 
            ul [] (List.concat (List.map makeLink links))
        ]

type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }

init : a -> (Model, Cmd Msg)
init _ =
    ( Model Time.utc (Time.millisToPosix 0)
    , Task.perform AdjustTimeZone Time.here
    )

subscriptions : a -> Sub Msg
subscriptions _ =
    Time.every 1000 Tick

leadingZero: String -> String
leadingZero digit =
    case length digit of
        1 -> 
            "0" ++ digit
        _ -> 
            digit

toJapaneseWeekday : Weekday -> String
toJapaneseWeekday weekday =
  case weekday of
    Mon -> "月曜日 | Getsuyoubi | Monday"
    Tue -> "火曜日 | Kayoubi | Tuesday"
    Wed -> "水曜日 | Suiyoubi | Wednesday"
    Thu -> "木曜日 | Mokuyoubi | Thursday"
    Fri -> "金曜日 | Kinyoubi | Friday"
    Sat -> "土曜日 | Doyoubi | Saturday"
    Sun -> "日曜日 | Nichiyoubi | Sunday"

toJapaneseMonth : Month -> String
toJapaneseMonth month =
  case month of
    Jan -> "一月 | ichigatsu | January"
    Feb -> "二月 | nigatsu | February"
    Mar -> "三月 | sangatsu | March"
    Apr -> "四月 | shigatsu | April"
    May -> "五月 | gogatsu | May"
    Jun -> "六月 | rokugatsu | June"
    Jul -> "七月 | shichigatsu | July"
    Aug -> "八月 | hachigatsu | August"
    Sep -> "九月 | kugatsu | September"
    Oct -> "十月 | juugatsu | October"
    Nov -> "十一月 | juuichigatsu | November"
    Dec -> "十二月 | juunigatsu | December"

toJapaneseMonthCounter : Month -> String
toJapaneseMonthCounter month =
  case month of
    Jan -> "1月"
    Feb -> "2月"
    Mar -> "3月"
    Apr -> "4月"
    May -> "5月"
    Jun -> "6月"
    Jul -> "7月"
    Aug -> "8月"
    Sep -> "9月"
    Oct -> "10月"
    Nov -> "11月"
    Dec -> "12月"

view: Model -> Html Msg
view model =
    let 
        hour   = leadingZero(String.fromInt (Time.toHour model.zone model.time))
        minute = leadingZero(String.fromInt (Time.toMinute model.zone model.time))
        second = leadingZero(String.fromInt (Time.toSecond model.zone model.time))
        day = String.fromInt (toDay model.zone model.time)
        weekday = toWeekday model.zone model.time
        month = toMonth model.zone model.time
        year = String.fromInt (toYear model.zone model.time)
    in
    div [ class "bg" ]
        [ div [ class "flex-container" ]
            [ makeBlock general
            , makeBlock programming
            , makeBlock boards
            , makeBlock translate
            , makeBlock downloads
            ]
        , div [ class "timeblocks" ] 
            [ text (hour ++ ":" ++ minute ++ ":" ++ second ++ " " ++ year ++ "年" ++ toJapaneseMonthCounter month ++ day ++ "日") ]
        , div [ class "timeblocks" ] [ text (toJapaneseWeekday weekday) ]
        , div [ class "timeblocks" ] [ text (toJapaneseMonth month) ]
        ]

type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )
