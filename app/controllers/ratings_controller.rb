# encoding: utf-8
class RatingsController < ApplicationController
  before_filter :can_rate

  def create
  	# TODO check current user is recipient of reply

    @rating = Rating.new(params[:rating])

    @rating.user_id  = @rating.interaction.message.recipient_id
    @rating.rater_id = current_user.id
    @rating.value    = params[:commit]=="⬆"

    @rating.save
     
    redirect_to params[:return_path]
  end

  private
  def can_rate
    # TODO move checks to model

    @message = Interaction.find(params[:rating][:interaction_id]).message
    if !@message.replied_to?
      flash[:error] = "Cannot rate messages"
    elsif @message.reply.recipient_id!=current_user.id
      flash[:error] = "Forbidden"
    end
    redirect_to params[:return_path] if flash[:error]

  end
end
