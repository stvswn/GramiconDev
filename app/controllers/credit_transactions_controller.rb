class CreditTransactionsController < ApplicationController
  respond_to :json, :html

  # def index
  #   @credit_transactions = CreditTransaction.all
  # end

  def new
    @credit_transaction = CreditTransaction.new
    @credit_transaction.amount = 10
    @user = current_user
  end

  def create
    @credit_transaction = CreditTransaction.new(params[:credit_transaction])
    @credit_transaction.user_id = current_user.id
    @credit_transaction.action = 'credit_account'

    respond_to do |format|
      if @credit_transaction.amount > 0 && @credit_transaction.amount < 11 && @credit_transaction.save
        format.json { 
          render :text => { :transaction => @credit_transaction, :new_balance => User.find(current_user.id).credits }.to_json
        }
      else
        format.json { 
          @user = current_user
          render :action => 'new'
        }
      end
    end
  end
end
