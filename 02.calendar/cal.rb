#!/usr/bin/env ruby
require 'optparse'
require 'date'

#デフォルト値を設定
options = {
  y: Date.today.year,
  m: Date.today.month
}

#OptionParserのオブジェクトを作成
opt = OptionParser.new

#オプションの定義
opt.on('-y YEAR', Integer) { |v| options[:y] = v }
opt.on('-m MONTH', Integer) { |v| options[:m] = v }

#コマンドライン引数（ARGV）を解析
opt.parse!(ARGV)
#引数から年月を変数に代入
year = options[:y]
month = options[:m]

#取得した年月を使ってその月の1日目の曜日を取得
first_date=Date.new(year,month,1)
#取得した年月を使ってその月の最終日付を取得
last_date=Date.new(year,month,-1)

#カレンダーの年月と曜日を表示(漢字7文字+半角スペース6文字分の文字列)
puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
#1日目の曜日までスペースで移動
first_date.wday.times do
  #漢字1文字+半角スペース1文字分開ける
  print "   "
end
(first_date..last_date).each do |date|
  # rjust(2) で桁数を揃え、後ろにスペースを1つ付与
  print date.day.to_s.rjust(2) + " "
  # 土曜日が来たら改行する
  puts if date.saturday?
end
puts
