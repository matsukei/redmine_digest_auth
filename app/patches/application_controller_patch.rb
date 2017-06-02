require_dependency 'application_controller'

module RedmineDigestAuth
  module ApplicationControllerPatch
    unloadable

    extend ActiveSupport::Concern

    included do
      unloadable

      before_filter :digest_auth_action
    end

    private

      def digest_auth_action
        return true if api_request?

        settings = Setting['plugin_redmine_digest_auth']
        return true if settings[:enabled_digest_auth].to_i.zero?

        # See: http://api.rubyonrails.org/classes/ActionController/HttpAuthentication/Digest.html
        authenticate_or_request_with_http_digest(settings[:realm]) do |username|
          Redmine::Ciphering.decrypt_text(settings[:password]) if settings[:username] == username
        end
      end

  end
end

RedmineDigestAuth::ApplicationControllerPatch.tap do |mod|
  ApplicationController.send :include, mod unless ApplicationController.include?(mod)
end
