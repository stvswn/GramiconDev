class FoldersController < ApplicationController
	before_filter :authenticate_user!
  	respond_to :json

	def update
		@folder = Folder.find(params[:id])
		@folder.update_attributes!(params[:folder])
		respond_with_bip(@folder)
	end

	def create
		@folder = Folder.new(params[:folder])
		@folder.user_id = current_user.id
		@folder.save
		redirect_to inbox_url
	end

end
