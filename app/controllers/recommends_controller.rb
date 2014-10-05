require 'json'
require 'jubatus/recommender/client'

class RecommendsController < ApplicationController
  HOST = '127.0.0.1'
  PORT = 9199
  NAME = 'nico unko recommender'

  def step_recommend(item, step)
    recommender = Jubatus::Recommender::Client::Recommender.new(HOST, PORT, NAME)
    result = recommender.similar_row_from_id(item, 5).inject({}) do |result, j|
      result[j.id] = j.score
      result
    end
    
    if step > 0
      next_step_results = {}
      result.each do |k, v|
        next if k == item
        step_recommend(k, step - 1).each do |nk, nv|
          next_step_results[nk] = 0 if next_step_results[nk].nil?
          next_step_results[nk] = nv if nv > next_step_results[nk]
        end
      end

      return next_step_results
    else
      return result
    end
  end

  def show
    @title = params[:title]
    @video_id = params[:video_id]
    step = 3
    result = Hash[step_recommend(@title, step).sort_by{ |k, v| -v}]
    rec_title = result.inject([]) do |rec_title, k, v|
      rec_title << k
    end
    @result = Video.where(title: rec_title)
  end
end
