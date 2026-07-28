#!/usr/bin/env ruby
require 'optparse'
require 'date'
#コマンドライン引数（ARGV）を解析
y=ARGV[0]
m=ARGV[1]
#OptionParserのオブジェクトを作成
opt = OptionParser.new

#オプションの定義
opt.on('-y YEAR', Integer) { |v| options[:y] = v }
opt.on('-m MONTH', Integer) { |v| options[:m] = v }

#デフォルト値を設定
options = {
  y: Date.today.year,
  m: Date.today.month
}

#コマンドライン引数（ARGV）を解析
opt.parse!(ARGV)
#引数から年月を変数に代入
year=options[:y]
month=options[:m]

#取得した年月を使ってその月の1日目の曜日を取得[日:0,月:1,...,土:6]
day1=Date.new(year,month,1).wday
#取得した年月を使ってその月の最終日付を取得
date_la=Date.new(year,month,-1).day

#カレンダーの年月と曜日を表示
puts "　　　#{month}月　#{year}　　　"
puts "日 月 火 水 木 金 土"
#1日目の曜日までスペースで移動
i=0
day1.times do |i|
    #漢字1文字+半角スペース1文字分開ける
    print "   "
end
#日付の記載を最終日まで繰り返す
i=0
d=day1
while i<date_la
    i=i+1
    #土曜日が来るまでdを増やす 
    d=d+1
    if i<10
        print " "
    end
    print "#{i} "
    #土曜日が来たら改行し、nをリセット
    if d%7==0
        puts ""
        d=0
    end
end
puts
