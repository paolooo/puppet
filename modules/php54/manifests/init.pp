class php54
{
  package { "python-software-properties":
    ensure  => present,
    require => Exec['php54 apt update']
  }
  
  #https://launchpad.net/~ondrej/+archive/php5
  exec { 'add php54 apt-repo':
    command => '/usr/bin/add-apt-repository ppa:ondrej/php5 -y',
    require => Package['python-software-properties']
  }

  exec { 'php54 apt update':
    command => '/usr/bin/apt-get update --fix-missing'
  }

  package { 'php5-cli':
    ensure  => installed,
    require => Exec['apt-get update']
  }

  package { ['php5-xdebug', 'php5-suhosin', 'php5-xsl']:
    ensure  => installed,
    require => Package['php5-cli'],
  }

  #file {
  #}

  #file {
  #}
}

