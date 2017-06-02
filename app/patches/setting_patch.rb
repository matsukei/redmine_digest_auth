require_dependency 'setting'

module RedmineDigestAuth
  module SettingPatch
    unloadable

    extend ActiveSupport::Concern

    included do
      unloadable

      class << self
        def plugin_redmine_digest_auth_with_ciphering=(value)
          value[:password] = Redmine::Ciphering.encrypt_text(value[:password])
          self.plugin_redmine_digest_auth_without_ciphering=(value)
        end
        # TODO: prepend
        alias_method_chain :plugin_redmine_digest_auth=, :ciphering

      end
    end

  end
end

RedmineDigestAuth::SettingPatch.tap do |mod|
  Setting.send :include, mod unless Setting.include?(mod)
end
