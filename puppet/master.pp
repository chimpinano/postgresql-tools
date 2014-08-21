# == Class: postgresql::master
#
# A class that defines everything needed for a postgresql master installation
# extends / inherits the postgresql::base class
#
# please note: all puppet code in this repository (including this one)
# is meant to be used together with the official puppet-postgresql repo
# that can be found here: https://github.com/puppetlabs/puppetlabs-postgresql 
#
# === Parameters
#
# Only one parameter for this class
#
# [*standalone*]
#   Set this parameter to true if you dont want replication specific settings
#   defaults to false
#
# === Variables
#
# None
#
# === Examples
#
#  class { 'postgresql::master':
#    standalone => true,
#  }
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::master($standalone=false) inherits postgresql::base{
  
  include postgresql::monitoring

  if $standalone == false {

    include postgresql::wal_settings_master
    include postgresql::wal_archiving

    #access rule for user YOURREPLICATORUSERNAME
    postgresql::server::pg_hba_rule{ 'YOURREPLICATORUSERNAME_pg_hba':
      type        => 'hostssl',
      address     => $::postgresql::params::ip_mask_ec2_eu_west,
      database    => 'replication',
      user        => $::postgresql::params::YOURREPLICATORUSERNAME,
      auth_method => 'md5',
      description => 'for allowing user YOURREPLICATORUSERNAME',
    }

  }

}