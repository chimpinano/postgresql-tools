# == Class: postgresql::roles::replicator
#
# A class that adds a replicator user to your postgresql installation
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
# Change: YOURREPLICATORUSERNAME and YOURREPLICATORPASSWORD in this class
# and in params.pp
#
# === Examples
#
# include postgresql::roles::replicator
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::roles::YOURREPLICATORUSERNAME {

  postgresql::server::role { $::postgresql::params::YOURREPLICATORUSERNAME:
    password_hash => postgresql_password(
      $::postgresql::params::YOURREPLICATORUSERNAME,
      $::postgresql::params::YOURREPLICATORPASSWORD),
    replication   => true,
  }

}
