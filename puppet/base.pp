# == Class: postgresql::base
#
# This is the base class that defines everything that both
# a postgreql master and a postgresql slave (standby) should have
#
# Including this class will result in a standalone postgresql installation
# that can be reached from 172.31.0.0/16 by users replicator 
# and postgres (over SSL)
#
# Although using just this class will work, inheriting it is 
# the intended way to go, check: postgresql::master and postgresql::slave 
#
# please note: all puppet code in this repository (including this one)
# is meant to be used together with the official puppet-postgresql repo
# that can be found here: https://github.com/puppetlabs/puppetlabs-postgresql 
#
# === Parameters
#
# Document parameters here.
#
# No parameters for the base class
#
# === Variables
#
# The only variable in this class you could set is the value 
# for ip_mask_allow_all_users, which is now hardcoded to
# our ec2 subnet
#
#
# === Examples
#
# include postgresql::base
# class postgresql::master inherits postgresql::base {
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::base{

  include postgresql::sslkeys
  include postgresql::logfile_layout

  include postgresql::roles::replicator
  include postgresql::roles::postgres

  #start installing the actual server!
  class { 'postgresql::server':
    #the ip_mask must be hardcoded for some stupid reason
    ip_mask_allow_all_users => '172.31.0.0/16',
    listen_addresses        => '*',
    manage_firewall         => false,
  }
  
  #more connections also means more memory
  if $::environment != 'staging' {
    postgresql::server::config_entry { 'max_connections':
      value => 250,
    }
  }

}