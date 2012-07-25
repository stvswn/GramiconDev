class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :html, :json

  def index
    @messages = Message.all
  end

  def show
    @message = Message.find(params[:id])
  end

  def update_state
    @message = Message.find(params[:id])
    return if current_user!=@message.recipient

    success = nil
    modal = nil
    if @message.claim_expired?
        type_name = 'unread'
        flash = "Unable to process, this gram has expired."
    else
      if params[:state] == 'claim'
        success = @message.open_it
        modal = 'messagemod'+@message.id.to_s
        if @message.type == 'Reply'
          type_name = 'claimedreplies'
        else
          type_name = 'claimed'
        end
        flash = "Successfully claimed gram."
      elsif params[:state] == 'hold'
        success = @message.hold
        type_name = 'onhold'
        flash = "Successfully put gram on hold."
      elsif params[:state] == 'dismiss'
        success = @message.dismiss
        type_name = 'unread'
        flash = "Gram dismissed."
      end
    end

    if success
      if modal
        redirect_to type_inbox_url(:type_name => type_name, :mod => modal ), :notice => flash 
      else
        redirect_to type_inbox_url(:type_name => type_name), :notice => flash
      end
    else
      redirect_to type_inbox_url(:type_name => type_name), :notice => flash
    end
  end

  def new
    @users = User.except_for_user(current_user).map { |user| [user.to_s,user.id] }.sort_by {|opt| opt[0].downcase}
    @message = Message.new
    @message.recipient_id = params[:to] if params.key?(:to)
  end

  def create
    credits = params[:message]['credits']
    params[:message].delete('credits')
    if params.key?(:replyto)
      @message = Reply.new(params[:message])
      @message.responded_to_id = params[:replyto]
      @message.recipient_id = Message.find(params[:replyto]).sender_id
    else
      @message = Message.new(params[:message])
    end
      
    @message.sender_id = current_user.id
    @message.credits = credits

    if @message.recipient_id==current_user.id
      redirect_to inbox_url, :notice => "Can't send message to yourself." 
      return 
    end

    if @message.save
      @message.send_off
      redirect_to inbox_url, :notice => "Successfully sent message."
    else
      @users = User.all.map { |user| [user.to_s,user.id] }.sort_by {|opt| opt[0].downcase}
      render :action => 'new'
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.html { 
          if @message.folder_id
            redirect_to folder_inbox_url(@message.folder_id), :notice  => "Successfully updated message."
          else
            redirect_to inbox_url, :notice  => "Successfully sent message."
          end
        }
        format.json { respond_with_bip(@message) }  
      else
        format.html { render :action => 'edit' }
        format.json { respond_with_bip(@message) }  
      end
    end
  end

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    redirect_to messages_url, :notice => "Successfully destroyed message."
  end
end
