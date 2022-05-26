# HTTP通信
using HTTP 
# JSON形式のデータを扱う
using JSON3
# データフレーム
using DataFrames
# 日付関係
using Dates

# APIのURL
const url = "https://api.cryptowat.ch/markets/bitflyer/btcjpy/ohlc"

# ローソク足のデータを格納する構造体
struct Candle
  time::DateTime
  open::Float64
  high::Float64
  low::Float64
  close::Float64
  volume::Float64
  quote_volume::Float64
end

function get_candles()
  # getメソッドでAPIにリクエストを投げる
  res = HTTP.get(url, query=Dict("periods"=>"60"))
  # HTTPレスポンスbodyにJSONが返ってくるのでparseする
  body = String(res.body)
  data = JSON3.read(body)
  # dictとしてparseしてくれるのでデータを格納している値を取り出す
  rows = data["result"]["60"] # 配列
  
  # Candle型の空の配列を用意
  candles = Candle[]
  for row in rows
    # rowはベクトルでtimestamp, open, high, low, close, volume, quote_volumeを要素に持つ
　  timestamp, open, high, low, close, volume, quote_volume = row # 展開
    time = Dates.unix2datetime(row[1]) # timestampをDates.DateTime型に変換
    candle = Candle(time, open, high, low, close, volume, quote_volume)
    push!(candles, candle)
  end
  
  return candles
end
