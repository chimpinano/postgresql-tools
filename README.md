postgresql
==========

This is our repository that hosts scripts and puppet code regarding to our two Postgresql blogposts.
- Our blogpost about Master slave replication: http://s6.io/postgresql-on-aws-with-puppet-high-availability-2/
- Our blogpost about backups and restoring: http://s6.io/postgresql-on-aws-with-puppet-backups-and-restore/

This all code that we at screen6 run in production, but **please note** that the puppet code needs to be combined with the puppet code from the official puppetlabs postgresql module, that can be found here: https://forge.puppetlabs.com/puppetlabs/postgresql or here: https://github.com/puppetlabs/puppetlabs-postgresql

The puppet code in this code is just our extention on the official module for our usecase.

If you have any questions about the usage of the code, i would like to ask you to read the two blogposts first. If after that you still have a question: feel free to comment on the blogpost, submit an issue, or even create a pull request.
