class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => :index
  helper_method :sort_column, :sort_direction

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { 
          redirect_to inbox_url, :notice  => "Successfully updated your profile."
        }
      else
        format.html { render :action => 'edit' }
      end
    end
  end

  def index
  	@users = User.search(  params[:sname],
                           params[:szipcode],
                           {:m=>params[:smale],:f=>params[:sfemale]},
                           params[:smaxage],
                           params[:sminage]
                           ).order(sort_column + " " + sort_direction)
  end

  def inbox
    @user = current_user
    @unread_messages_count = @user.received_messages.where(:state => 'sent').count
    @onhold_messages_count = @user.received_messages.where(:state => 'held').count

    @type = params.key?(:type_name) ? params[:type_name] : 'unread'

    if @type == 'sent'
      @messages = @user.sent_messages
      @type_title = 'Sent Grams'
    else
      @messages = @user.received_messages
      if @type=='unread'
        @replies = @messages.where(:state => 'sent', :type => 'Reply').sort_by {|message| message.credits}.reverse
        @messages = @messages.where(:state => 'sent', :type => 'Message').delete_if { |message| message.claim_expired? }.sort_by {|message| message.credits}.reverse
        @type_title = 'Unread Grams'
      elsif @type=='claimed'
        @messages = @messages.where(:state => 'opened', :type => 'Message')
        @type_title = 'Claimed Grams'
      elsif @type=='claimedreplies'
        @messages = @messages.where(:state => 'opened', :type => 'Reply')
        @type_title = 'Claimed Grams'
      elsif @type=='onhold'
        @messages = @messages.where(:state => 'held', :type => 'Message').sort_by {|message| message.credits}.reverse
        @type_title = 'Grams on Hold'
      end
    end


    # @folders = @user.folders
    # @folder = @folders.find(params[:folder_id]) if params.key?(:folder_id)
    # if @folder
    # 	@messages = @messages.where(:folder_id => @folder.id)
    # else
  		# @messages = @messages.where(:folder_id => nil)
    # end
    # @folder_for_select = [["Inbox",nil]] + @folders.map{ |folder| [folder.name, folder.id] }.sort_by {|opt| opt[0].downcase}
  end



  private
  
  def sort_column
    puts User.column_names.include?(params[:sort])
    puts params[:sort]
    User.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end
