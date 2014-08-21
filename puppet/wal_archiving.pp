# == Class: postgresql::wal_archiving
#
# This class will set the wal_archiving settings for your postgresql
# this class intended to be included from a postgresql master, since 
# wal archiving is typically used for master-slave replication
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
# include postgresql::wal_archiving
# 
# === Authors
#
# Erik Bergsma erikbergsma@screen6.io
#
# === Copyright
#
# Copyright 2014 Screen6.io
#
class postgresql::wal_archiving(){

  case $::environment {
    'staging': {
      postgresql::server::config_entry { 'archive_mode':
        value   => 'off',
      }
    } default: {
      postgresql::server::config_entry { 'archive_mode':
        value   => 'on',
      }

      postgresql::server::config_entry { 'archive_command':
        value => 'bash /path/to/backup_incremental.sh %p %f',
      }

      postgresql::server::config_entry { 'archive_timeout':
        value   => '60',
      }
    }
  }
}
