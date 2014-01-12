class phpmyadmin {
  # package { 'phpmyadmin':
  #   ensure  => present,
  # }

  case $::operatingsystem {
    'RedHat', 'Fedora', 'CentOS', 'Scientific', 'SLC', 'Ascendos', 'CloudLinux', 'PSBM', 'OracleLinux', 'OVS', 'OEL': {
      $conf = "/etc/httpd/conf.d/phpMyAdmin.conf"
    }

    'ubuntu', 'debian': {
      $conf = "/etc/apache2/sites-enabled/phpMyAdmin.conf"
    }
  }

  exec { "install-phpmyadmin": 
      command => "wget /tmp 'http://dl.cihar.com/phpMyAdmin/master/phpMyAdmin-master-latest.tar.bz2#!md5!a06b6a6a4133a7f2035cfb31e67981cc' && tar xvfj phpMyAdmin-master-latest.tar.bz2 && rm phpMyAdmin-master-latest.tar.bz2 && mv phpMyAdmin-master-2* phpmyadmin && cp phpmyadmin/config.sample.inc.php phpmyadmin/config.inc.php  && mv phpmyadmin /usr/share"
    , cwd => "/tmp"
    , unless => "test -d /usr/share/phpmyadmin"
  }

  file { $conf:
    owner   => "root"
    , group   => "root"
    , mode    => 644
    , replace => true
    , ensure  => present
    , source  => "/vagrant/files/phpMyAdmin.conf"
    , require => Package["httpd"]
    , notify  => Service["httpd"]
  }

  # file { 'phpmyadmin_config':
  #   path    => '/etc/phpmyadmin/config.inc.php',
  #   content => template('phpmyadmin/config.inc.php'),
  #   ensure  => file,
  #   owner   => root,
  #   group   => 0,
  #   mode    => 0444,
  #   require => Package['phpmyadmin']
  # }
}
