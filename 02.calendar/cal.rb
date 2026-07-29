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

#取得した年月を使ってその月の1日目の曜日を取得[日:0,月:1,...,土:6]
first_day=Date.new(year,month,1).wday
#取得した年月を使ってその月の最終日付を取得
last_date=Date.new(year,month,-1).day

#カレンダーの年月と曜日を表示(漢字7文字+半角スペース6文字分の文字列)
puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"
#1日目の曜日までスペースで移動
i=0
first_day.times do |i|
  #漢字1文字+半角スペース1文字分開ける
  print "   "
end
#日付の記載を最終日まで繰り返す
d=first_day
(1..last_date).each do |i|
  #土曜日が来るまでdを増やす 
  d+=1
  if i<10
    print " "
  end
  print "#{i} "
  #土曜日が来たら改行し、nをリセット
  if (first_day+i)%7==0
    puts ""
    d=0
  end
end
puts
