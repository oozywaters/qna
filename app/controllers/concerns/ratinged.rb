module Ratinged
  extend ActiveSupport::Concern

  included do
    before_action :find_resource, only: [:vote_up, :vote_down, :vote_reset]
    before_action :vote_access, only: [:vote_up, :vote_down]
  end

  def vote_up
    @resource.vote_up(current_user)
    render_json_details
  end

  def vote_down
    @resource.vote_down(current_user)
    render_json_details
  end

  def vote_reset
    if @resource.voted_by?(current_user)
      @resource.vote_reset(current_user)
      render_json_details
    else
      head :unprocessable_entity
    end
  end

  private

  def vote_access
    if @resource.voted_by?(current_user) || current_user.author_of?(@resource)
      head :unprocessable_entity
    end
  end

  def find_resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end

  def render_json_details
    render json: { rating: @resource.rating, klass: @resource.class.to_s, id: @resource.id }
  end
end
