# Default path
Exec {
  path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/local/sbin', '/opt/local/bin'],
}

exec { 'apt-get update':
  command => '/usr/bin/apt-get update --fix-missing'
}

# Configuration
if $db_name == '' { $db_name = 'development' }
if $db_location == '' { $db_location  = '/vagrant/db/development.sqlite' }
if $username == '' { $username = 'root' }
if $password == '' { $password = '123' }
if $host == '' { $host = 'localhost' }

#Packages
include apache
include php54

#package { ['vim','curl','unzip','phpunit','php-pear','memcache','php5-cli','php5-dev','php5-mcrypt','php5-sqlite']:
package { ['vim','curl','unzip']:
  ensure  => 'installed',
  require => [Exec['apt-get update'], Package['python-software-properties']]
}

#include mysql
#include postgresql
#include sqlite


# Setup
## Apache
class {'apache::mod::php': }

apache::vhost { $fqdn:
  priority  => '20',
  port => '80',
  docroot => $docroot,
  configure_firewall  => false,
}

a2mod { 'rewrite': ensure => present }

## PHP
class { 'php':
  version => latest,
}

php::module { ['xdebug', 'mysql', 'curl', 'gd']:
  notify  => [ Service['httpd'], ],
}

php::pear::module { 'XML_Util': }


### MySQL Server
#class { 'mysql::server':
#  config_hash => { 'root_password' => "${password}" }
#}
#
#mysql::db { "${db_name}":
#  user  => "${username}",
#  password  => "${password}",
#  host  =>  "${host}",
#  grant => ['all'],
#  charset => 'utf8',
#}
#
### PostgreSQL Server
#class { 'postgresql::server': }
#
#postgresql::db { "${db_name}":
#  user => "${db_name}",
#  password  => "${password}",
#}
#
### SQLite Config
#define sqlite::db(
#    $location   = '',
#    $owner      = 'root',
#    $group      = 0,
#    $mode       = '755',
#    $ensure     = present,
#    $sqlite_cmd = 'sqlite3'
#  ) {
#
#      file { $safe_location:
#        ensure  => $ensure,
#        owner   => $owner,
#        group   => $group,
#        notify  => Exec['create_development_db']
#      }
#
#      exec { 'create_development_db':
#        command     => "${sqlite_cmd} $db_location",
#        path        => '/usr/bin:/usr/local/bin',
#        refreshonly => true,
#      }
#  }

