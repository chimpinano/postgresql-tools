# == Class: postgresql::logfile_layout
#
# A simple class, describing the logfolder hack we have to use
# Note: The folder structure and usernames may be ubuntu specific
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
# include postgresql::logfile_layout
#
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::logfile_layout{
  
  require postgresql::params

  # we symlink this to the dedicated partition,
  # the base partition is often only 8gb so not big enough for the logs.
  file { '/var/lib/postgresql/logs':
    ensure  => directory,
    mode    => '0770',
    group   => 'postgres',
    require => Package[$postgresql::params::server_package_name],
  }

  file { '/var/log/postgresql':
    ensure  => 'link',
    force   => true,
    target  => '/var/lib/postgresql/logs',
    require => File['/var/lib/postgresql/logs'],
  }

}