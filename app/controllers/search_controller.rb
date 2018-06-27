class SearchController < ApplicationController
  def index
    query = params[:query]
    category = params[:category]
    @resources = Search.find(query, category) if query
  end
end
