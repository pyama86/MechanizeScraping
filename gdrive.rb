#!/usr/bin/env ruby
#coding: utf-8

module Gdrive 
    class SpreadSheet
        require 'google_drive'
        attr_accessor :g,:s
        def initialize( id=nil, password=nil, sheetid=nil )
            @@id = id
            @@password = password
            @@sid = sheetid
        end
        # ログイン
        def login(id=nil,password=nil)
            id ||= @@id
            password ||= @@password
            sid ||= @@sid
            @g = GoogleDrive.login(id, password)
            @s  = @g.spreadsheet_by_key(sid).worksheets[0]
        end

        # データ追加
        def addData(lst)
            rn = 1
            cn = 1
            lst.each{|row|
              row.each{|col|
                @s[rn,cn] = col.to_s
                cn += 1
              }
              cn = 1
              rn += 1
            }
            @s.save
        end
    end

end
