# == Class: postgresql::wal_settings_slave
#
# This will set postgresql WAL specific settings for your installation
# These settings are ment to be used on a postgresql slave / stanby node
#
# please note: all puppet code in this repository (including this one)
# is meant to be used together with the official puppet-postgresql repo
# that can be found here: https://github.com/puppetlabs/puppetlabs-postgresql 
#
# === Parameters
#
# None
#
# === Variables
#
# None
#
# === Examples
#
#  include postgresql::wal_settings_slave
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::wal_settings_slave{

  postgresql::server::config_entry { 'wal_level':
    value   => 'hot_standby',
  }

  postgresql::server::config_entry { 'hot_standby':
    value   => 'on',
  }

}
