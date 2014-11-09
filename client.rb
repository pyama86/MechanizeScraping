#!/usr/bin/env ruby
#coding:utf-8
require "./amazon.rb"
require "./gdrive.rb"

amazonId = ENV["AMAZONID"] 
amazonPass = ENV["AMAZONPASS"]

googleId = ENV["GOOGLEID"]
googlePass = ENV["GOOGLEPASS"]
googleSheetId = ENV["SHEETID"]

# アマゾンからデータを取得
amazon = AmazonScraper::Amazon.new amazonId, amazonPass
amazon.login
amazon.goRireki
lst = amazon.getList

# スプレッドシートにデータを吐く
google = Gdrive::SpreadSheet.new googleId, googlePass, googleSheetId
google.login
google.addData lst

