class php54
{
  package { "python-software-properties":
    ensure => present,
    require => Exec['apt-get update']
  }

  #https://launchpad.net/~ondrej/+archive/php5
  exec {  'add php54 apt-repo':
    command => '/usr/bin/add-apt-repository ppa:ondrej/php5 -y',
    require => Package['python-software-properties'],
  }
}

