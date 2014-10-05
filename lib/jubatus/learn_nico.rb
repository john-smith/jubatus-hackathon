# -*- coding: utf-8 -*-
require 'zlib'
require 'json'
require 'jubatus/recommender/client'

HOST = '127.0.0.1'
PORT = 9199
NAME = 'nico unko recommender'

recommender = Jubatus::Recommender::Client::Recommender.new(HOST, PORT, NAME)

# 利用動画数や再生数の閾値は学習時間やマシンスペックにあわせて
range = 1800..1925
threshold = 1000

file_nums = range.to_a.shuffle.each do |f|
  f = sprintf("%04d", f)
  items = Zlib::GzipReader.open("/vagrant/data/video/#{f}.dat.gz").inject([]) do |items, i|
    json = JSON.parse(i)
    items << json
  end
  
  items.shuffle.each do |json|
    if json['view_counter'] >= threshold
      title = json['title']
      param = json['tags'].inject({}) do |param, j|
        # update_rowでは$を含む文字列はダメっぽい
        param[j['tag']] = 1 if !j['tag'].include?('$')
        param
      end
      datum = Jubatus::Common::Datum.new(param)
      recommender.update_row(title, datum)
    end
  end
end
