Redmine::Plugin.register :redmine_digest_auth do
  name 'Redmine Digest Auth plugin'
  author 'Matsukei Co.,Ltd'
  description 'It is a plugin that provides digest authentication to Redmine.'
  version '1.0.0'
  url 'https://github.com/matsukei/redmine_digest_auth'
  author_url 'http://www.matsukei.co.jp/'

  settings(partial: 'digest_auths/settings',
    default: {
      enabled_digest_auth: 0,
      realm: 'SecretRedmine'
    })

end

require_relative 'lib/redmine_digest_auth'
