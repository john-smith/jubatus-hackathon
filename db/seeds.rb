# -*- coding: undecided -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#File.open("/vagrant/data/gen/title_min.tsv").each do |i|

# 利用動画数や再生数の閾値は学習時間やマシンスペックにあわせて
range = 1800..1925
threshold = 1000

file_nums = range.to_a.shuffle.each do |f|
  f = sprintf("%04d", f)
  Zlib::GzipReader.open("/vagrant/data/video/#{f}.dat.gz").each do |i|
    json = JSON.parse(i)

    if json['view_counter'] >= threshold
      @video = Video.new
      @video.video_id = json['video_id']
      @video.title = json['title']
      @video.save
    end
  end
end
