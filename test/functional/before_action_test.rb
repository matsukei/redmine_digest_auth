require File.expand_path('../../test_helper', __FILE__)

class RedmineDigestAuth::BeforeActionTest < ActionController::TestCase
  include RedmineDigestAuth::TestHelper
  tests ProjectsController

  fixtures :projects, :trackers, :issue_statuses, :issues, :users

  def setup
    User.current = User.find_by_login('admin')
  end

  def teardown
    Setting.delete_all
    Setting.clear_cache
  end

  def test_get_login_url_without_digest_auth
    with_settings(disable_digest_auth_settings) do
      get :index
      assert_not_request_digest_auth
    end
  end

  def test_xhr_login_url_without_digest_auth
    with_settings(disable_digest_auth_settings) do
      get :index, format: :json
      assert_not_request_digest_auth
    end
  end

  def test_get_login_url_with_digest_auth
    with_settings(enable_digest_auth_settings) do
      # Case: get nonce and opaque
      get :index
      assert_request_digest_auth

      [
        # Case: mistook username and password.
        [ 'test-user-002', 'fugafuga' ],
        # Case: mistook username.
        [ 'test-user-002', 'hogehoge' ],
        # Case: mistook password.
        [ 'test-user-001', 'fugafuga' ]
      ].each do |digest_info|
        @request.env['HTTP_AUTHORIZATION'] = authorization_value(*digest_info)
        get :index
        assert_request_digest_auth
      end

      # Case: correct username and password.
      @request.env['HTTP_AUTHORIZATION'] = authorization_value('test-user-001', 'hogehoge')
      get :index
      assert_not_request_digest_auth
    end
  end

  def test_xhr_login_url_with_digest_auth
    with_settings(enable_digest_auth_settings) do
      get :index, format: :json
      assert_not_request_digest_auth
    end
  end

end
