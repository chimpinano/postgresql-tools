# == Class: postgresql::slave
#
# A class that defines everything needed for a postgresql 
# slave /standby installation, extends / inherits 
# the postgresql::base class
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
# include postgresql::slave
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::slave inherits postgresql::base{

  include postgresql::wal_settings_slave

  icinga::defines::servicecheck{ 'Replication delay':
    check_command => 'check_postgres_slave_rep_delay!50!100',
    check_period  => 'nonnight',
  }

  icinga::defines::servicecheck{ 'Replication delay local':
    check_command => 'check_nrpe_postgres_slave_rep_delay_local',
    check_period  => 'nonnight',
  }

}