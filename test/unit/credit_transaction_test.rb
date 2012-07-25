require 'test_helper'

class CreditTransactionTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert CreditTransaction.new.valid?
  end
end
