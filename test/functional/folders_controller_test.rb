require 'test_helper'

class FoldersControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => Folder.first
    assert_template 'show'
  end
end
