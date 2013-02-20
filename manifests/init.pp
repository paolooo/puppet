# Default path
include apt
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
include php54
include apache

package { ['vim','curl','unzip','git','php5-cli','php5-common','php5-xdebug','php5-mysql','php5-mcrypt','php5-suhosin','php5-memcache','php5-sqlite','php5-xsl','php5-tidy','php5-dev']:
  ensure  => 'installed',
  require => [Exec['apt-get update']]
}

package { ['php5-cgi']:
  ensure  => installed,
  require => Exec['apt-get update'],
}

include pear
include mysql
include postgresql
include sqlite
include composer

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

php::module { ['curl', 'gd','gearman','inotify','sphinx','oauth','imap','intl','xhprof','proctitle','pecl-http','mogilefs','igbinary','gmagick']:
  notify  => [ Service['httpd'], ],
}

## PEAR
pear::package { "PEAR": }
pear::package { "PHPUnit": 
  version     => "latest",
  repository  => "pear.phpunit.de",
  require     => Pear::Package["PEAR"],
}

## MySQL Server
class { 'mysql::server':
  config_hash => { 'root_password' => "${password}" }
}

mysql::db { "${db_name}":
  user  => "${username}",
  password  => "${password}",
  host  =>  "${host}",
  grant => ['all'],
  charset => 'utf8',
}

## PostgreSQL Server
class { 'postgresql::server': }

#postgresql::db { "${db_name}":
#  user => "${db_name}",
#  password  => "${password}",
#}


## SQLite Config
define sqlite::db(
    $location   = '',
    $owner      = 'root',
    $group      = 0,
    $mode       = '755',
    $ensure     = present,
    $sqlite_cmd = 'sqlite3'
  ) {

      file { $safe_location:
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        notify  => Exec['create_development_db']
      }

      exec { 'create_development_db':
        command     => "${sqlite_cmd} $db_location",
        path        => '/usr/bin:/usr/local/bin',
        refreshonly => true,
      }
  }

## Ruby
class { "ruby": 
  gems_version => "latest"
}

## Nodejs
class { "nodejs": }
