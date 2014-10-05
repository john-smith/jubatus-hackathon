class VideosController < ApplicationController
  def index
    #@videos =Video.all
    limit = 30
    page = params[:page]
    page = 1 if page.nil?
    @page = page.to_i
    offset = (@page - 1) * limit
    
    @videos =Video.offset(offset).limit(limit)
  end
end
