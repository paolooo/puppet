class composer {

  file { '/home/vagrant/bin':
    ensure => directory,
    owner  => 'vagrant',
    before => Package['curl'],
  }

  exec { 'install composer':
    command => '/usr/bin/curl -s http://getcomposer.org/installer | /usr/bin/php -- --install-dir=/home/vagrant',
    path    => '/home/vagrant',
    require => Package['curl','php5-cli'],
    creates => '/home/vagrant/composer.phar'
  }

  # move file to bin
  file { '/usr/local/bin/composer':
    ensure  => present,
    source  => '/home/vagrant/composer.phar',
    mode    => '0755',
    owner   => 'vagrant',
    group   => 'vagrant',
    require => Exec['install composer'],
  }

  # update composer
  exec { 'update composer':
    command => "/usr/local/bin/composer self-update",
    require => File['/usr/local/bin/composer']
  }
}
