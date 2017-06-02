# Redmine digest auth plugin

It is a plugin that provides digest authentication to Redmine.

## Usage

* Administrator > Plugins > Configure > checked `Enable Digest Authentication` and input digest auth settings.
* If you want to encrypt the password you entered, register `database_cipher_key` in `your_redmine_path/config/configuration.yml` .
  * When registering or changing `database_cipher_key`, please do after unchecking `Enable Digest Authentication` in digest authentication setting. Please enter the password again afterwards.
  * If you are already registering SCM or LDAP password, please carefully read the notes in `your_redmine_path/config/configuration.yml`, such as by running `rake db:encrypt RAILS_ENV=production` .
* As a last resort, you can reset digest authentication settings with the following command:
```
$ cd your_redmine_path
$ bundle exec rails console -e production
> record = Setting.where(name: 'plugin_redmine_digest_auth').first
> record.destroy
> exit
```
Then restart the web service.

## Screenshot

*Administrator > Plugins > Configure*

You can change Digest authentication settings without restarting the web service.

![settings](https://cloud.githubusercontent.com/assets/943541/26665167/94812b4e-46d2-11e7-87e9-760134fbc646.png)

## Install

1. git clone or copy an unarchived plugin to plugins/redmine_digest_auth on your Redmine path.
2. `$ cd your_redmine_path`
3. `$ bundle install`
4. web service restart

## Uninstall

1. `$ cd your_redmine_path`
2. remove plugins/redmine_digest_auth
3. web service restart

## Not improved

1. Re-authentication interval: 5 minutes
  * If you do not operate anything, you will be asked again in [about 5 minutes](https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/http_authentication.rb#L317) after authentication.
2. There are exceptions where digest authentication is not required. It is a static file URL directly under the public folder and a URL with no routing definitions.
  * For implementation via before_action, static files can be referenced.

## License

[The MIT License](https://opensource.org/licenses/MIT)
