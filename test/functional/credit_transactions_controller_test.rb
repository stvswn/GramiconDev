require 'test_helper'

class CreditTransactionsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    CreditTransaction.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    CreditTransaction.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to credit_transactions_url
  end
end
