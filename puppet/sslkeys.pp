# == Class: postgresql::sslkeys
#
# This class will add the sslkeys and certs to your postgresql installation
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
# include postgresql::sslkeys
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::sslkeys{

  require postgresql::params

  file { "${::postgresql::params::datadir}/server.key":
    ensure => file,
    mode   => '0400',
    owner  => $::postgresql::params::user,
    group  => $::postgresql::params::group,
    source => 'puppet:///modules/postgresql/server.key',
    before => Service['postgresql'],
  }

  file { "${::postgresql::params::datadir}/server.crt":
    ensure => file,
    mode   => '0400',
    owner  => $::postgresql::params::user,
    group  => $::postgresql::params::group,
    source => 'puppet:///modules/postgresql/server.crt',
    before => Service['postgresql'],
  }

}