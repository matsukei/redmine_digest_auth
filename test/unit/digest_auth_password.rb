require File.expand_path('../../test_helper', __FILE__)

class RedmineDigestAuth::PasswordTest < ActiveSupport::TestCase

  def test_password_should_be_encrypted
    Redmine::Configuration.with 'database_cipher_key' => 'secret' do
      Setting.plugin_redmine_digest_auth = {
        :enabled_digest_auth => '1',
        :realm => 'SecretRedmine',
        :username => 'user',
        :password => 'hogehoge'
      }

      password = Setting.plugin_redmine_digest_auth[:password]
      assert_not_equal 'hogehoge', password
      assert password.match(/\Aaes-256-cbc:.+\Z/)
    end
  end

  def test_password_should_be_clear_with_blank_key
    Redmine::Configuration.with 'database_cipher_key' => '' do
      Setting.plugin_redmine_digest_auth = {
        :enabled_digest_auth => '1',
        :realm => 'SecretRedmine',
        :username => 'user',
        :password => 'hogehoge'
      }
      assert_equal 'hogehoge', Setting.plugin_redmine_digest_auth[:password]
    end
  end

  def test_password_should_be_clear_with_nil_key
    Redmine::Configuration.with 'database_cipher_key' => nil do
      Setting.plugin_redmine_digest_auth = {
        :enabled_digest_auth => '1',
        :realm => 'SecretRedmine',
        :username => 'user',
        :password => 'hogehoge'
      }
      assert_equal 'hogehoge', Setting.plugin_redmine_digest_auth[:password]
    end
  end

end
