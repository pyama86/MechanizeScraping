#!/usr/bin/env ruby
#coding: utf-8

module AmazonScraper

    class Amazon 
        require 'mechanize'
        class Mechanize::HTTP::Agent
            def post_connect uri, response, body_io # :yields: agent, uri, response, body
                @post_connect_hooks.each do |hook|
                    begin
                        hook.call self, uri, response, body_io
                    ensure
                        body_io.rewind
                    end
                end
            end
        end
        attr_accessor :a
        def initialize( id=nil, password=nil )
            @a = Mechanize.new
            @a.user_agent_alias = 'Windows IE 7'
            @@id = id
            @@password = password
            @@amazonUrl = "http://www.amazon.co.jp"
            self.enable_force_encoding
        end
        
        def enable_force_encoding
            @a.post_connect_hooks << lambda{|ua,uri,res,body_io|
                if res["Content-Type"] =~ /^text\/.*$/
                    body =  NKF.nkf('-wxm0',body_io.read)
                    body.gsub! /shift-jis/i,"utf-8"
                    body_io.truncate body_io.pos
                    body_io.rewind
                    body_io.puts body
                end
            }

        end

        def login(id=nil,password=nil)
            id ||= @@id
            password ||= @@password
            @a.get @@amazonUrl
            @a.page.links_with( :text => "サインイン").first.click
            @a.page.forms[0].fields_with(:name=>"email").first.value = id
            @a.page.forms[0].fields_with(:name=>"password").first.value = password
            @a.page.forms[0].submit
        end

        # 注文履歴を開く
        def goRireki
          @a.page.links_with( :text=>"注文履歴を見る").first.click
        end
        
        # 注文履歴を取得する
        def getList
          result = Array.new
          list = @a.page.search('.a-fixed-left-grid-inner .a-row .a-link-normal')
          list.each{|e|
            result << [e.to_s.gsub(/<\/?[^>]*>/,"").gsub(/^\s+|\s+$/,""), @@amazonUrl + e["href"]] if(e.to_s.include?("/gp/product"))
          }
          @a.page.links_with( :text => "サインアウト").first.click
          return result
        end
    end

end
