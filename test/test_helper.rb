# Load the Redmine helper
require File.expand_path(File.dirname(__FILE__) + '/../../../test/test_helper')

module RedmineDigestAuth
  module TestHelper
    require 'digest/md5'

    def enable_digest_auth_settings
      {
        plugin_redmine_digest_auth: {
          enabled_digest_auth: 1,
          realm: 'SecretRedmine',
          username: 'test-user-001',
          password: 'hogehoge'
        }
      }
    end

    def disable_digest_auth_settings
      {
        plugin_redmine_digest_auth: {
          enabled_digest_auth: 0,
          realm: 'SecretRedmine',
          username: 'test-user-002',
          password: 'fugafuga'
        }
      }
    end

    def authorization_value(username, password)
      www_auths = {}
      response.header['WWW-Authenticate'].split(', ').each do |key_and_value|
        next if key_and_value =~ /Digest\srealm/
        www_auths.store($1, $2) if key_and_value =~ /(.+)=\"(.+)\"/
      end

      ActionController::HttpAuthentication::Digest.encode_credentials('GET', {
        uri: request.url, realm: "SecretRedmine", username: username,
        nonce: www_auths['nonce'], opaque: www_auths['opaque']
      }, password, false)
    end

    def assert_request_digest_auth
      assert_response 401
      assert_include 'Digest realm="', response.header['WWW-Authenticate']
      assert_include 'HTTP Digest: Access denied.', response.body
    end

    def assert_not_request_digest_auth
      assert_response :success
      assert_nil response.header['WWW-Authenticate']
      assert_not_include 'HTTP Digest: Access denied.', response.body
    end

  end
end
