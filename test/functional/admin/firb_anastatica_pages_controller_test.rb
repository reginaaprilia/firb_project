require File.dirname(__FILE__) + '/../../test_helper'

class Admin::FirbAnastaticaPagesControllerTest < ActionController::TestCase

  include TaliaUtil::TestHelpers

  def setup
    @page = FirbAnastaticaPage.create_page(:title => 'me title', :page_position => '3rb')
    @page.save!
    TaliaUtil::Util.flush_rdf
  end

  def teardown
    TaliaUtil::Util.flush_db
  end

  def test_index_login
    login_for(:admin)
    get(:index)
    assert_equal(@controller.send(:current_user), users(:admin))
  end

  def test_index
    login_for(:admin)
    get(:index)
    assert_response(:success)
    assert_select('div.aside')
    assert_select('h2.heading')
    assert_select('ul.collection') { assert_select('li.item', 1) }
  end

  def test_show
    login_for(:admin)
    get(:show, :id => @page.id)
    assert_response(:success)
    assert_select 'div.page-position', "Page position: #{@page.page_position}"
    assert_select 'span.firb-anastatica-page-name', @page.name
  end

  def test_new
    login_for(:admin)
    get(:new)
    assert_response(:success)
    assert_select 'th.page-position-label'
    assert_select 'th.title-label'
    assert_select 'input.submit-button'
  end

  def test_create
    assert_difference('FirbAnastaticaPage.count', 1) do
      post(:create, :firb_anastatica_page => { :title => 'Noo titeel', :page_position => 'xvrzf' })
      assert_response(302)
    end
    new_page = FirbAnastaticaPage.last
    assert_equal('Noo titeel', new_page.title)
    assert_equal('xvrzf', new_page.page_position)
  end

  def test_edit
    login_for(:admin)
    get(:edit, :id => @page.id)
    assert_response(:success)
    assert_select 'th.page-position-label'
    assert_select 'th.title-label'
    assert_select 'input.submit-button'
  end

  def test_update
    post(:update, :id => @page.id, :firb_anastatica_page => { :title => 'Noo titeel', :page_position => 'xvrzf' })
    assert_response(302)
    new_page = FirbAnastaticaPage.last
    assert_equal('Noo titeel', new_page.title)
    assert_equal('xvrzf', new_page.page_position)
  end


end