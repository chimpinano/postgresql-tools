# == Class: postgresql::roles::postgres
#
# This class will add 'superuser' postgres to your postresql installation
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
#  include postgresql::roles::postgres
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::roles::postgres {

  # a role is the name for user in postgresql
  postgresql::server::role { 'postgres':
    superuser => true,
  }
  
}