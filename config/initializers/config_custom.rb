# Define a configset by ENV['RAILS_CONFIGSET'] || default, then do the following:
# - if config/settings/configsets/set_name.yml exists, then add its contents to the config settings.
#   This file is intended for things that may vary machine to machine, but do not contain secrets
# - if credentials.yml.enc has a configsets[set_name] key, then add its contents to the config settings.
#   This is intended for things that have secrets. Note that because of the way the config gem works
#   it may be that not just the credentials need to go here - e.g. there is no apparent way to inject
#   credentials into each object of an array of objects, for example.

#Probably this is useful primarily in a production environment - for dev/test environments more of the stuff
# should be settable directly (for consistency) or via the test.local/development.local files (for an individual's
# unique dev environment)
#
# The raison d'etre here is to allow us to keep Rails-y environment settings (e.g. caching, class loading behavior, etc.)
# using the tradition Rails environment while allowing us to inject information that may vary from machine to machine
# for various production environments. I.e. the -prod and -demo environments are mostly the same as far as Rails is
# concerned, but may do things like connect to different servers/buckets/etc.

#Config needs to be loaded, as do the secrets in credentials.yml.enc, before this will work.
require_relative 'config'

configset = ENV['RUBY_CONFIGSET'] || 'default'
config_file = File.join(Rails.root, 'config', 'settings', 'configsets', "#{configset}.yml")
if File.exist?(config_file)
  Settings.add_source!(config_file)
end
credential_configset = (Rails.application.credentials.configsets[configset.to_sym] rescue nil)
if credential_configset
  Settings.add_source!(credential_configset.to_h)
end
Settings.reload!
