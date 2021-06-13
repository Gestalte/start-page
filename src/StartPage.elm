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
subscriptions model =
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
    div [class "bg"]
        [ div 
            [ style "margin-left" "20px"
            , style "padding-top" "10px"
            ] 
            [ text (hour ++ ":" ++ minute ++ ":" ++ second ++ " " ++ year ++ "年" ++ toJapaneseMonthCounter month ++ day ++ "日") ]
        , div [style "margin-left" "20px"] [ text (toJapaneseWeekday weekday) ]
        , div [style "margin-left" "20px"] [ text (toJapaneseMonth month) ]
        , div [ class "flex-container" ]
            [ makeBlock general
            , makeBlock programming
            , makeBlock boards
            , makeBlock translate
            , makeBlock torrents
            ]
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