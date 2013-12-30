class php5
{
  # class { "apt": }

  # apt::ppa {
  #   "ppa:ondrej/php5":
  #   # "ppa:nathan-renniewaldock/+archive/ppa":
  #   # "ppa:ondrej/+archive/php5":
  #   # "ppa:zanfur/php5.5":
  # , require => [ Package ["python-software-properties"] ]
  # }
  # 
  # exec { 'add php5 apt-repo':
  #   # command => "add-apt-repository ppa:ondrej/php5 -y" # php 5.3
  #   # command => "add-apt-repository ppa:nathan-renniewaldock/+archive/ppa -y" # php 5.4
  #   # command => "add-apt-repository ppa:ondrej/php5-oldstable -y" # php 5.4
  #   # command => "add-apt-repository ppa:ondrej/+archive/php5 -y" # php 5.5
  #   command => "add-apt-repository ppa:zanfur/php5.5 -y" # php 5.5
  # , require => [ Package["python-software-properties"] ]
  # }

  # exec { 'apt-get update':
  #   command => "apt-get update --fix-missing"
  # , require => [ Apt::Ppa["ppa:ondrej/php5"] ]
  # }

  package { 'php5-cli':
    ensure  => installed
  # , require => [ Apt::Ppa["ppa:ondrej/php5"] ]
  }

  package { ['php5-xdebug', 'php5-xsl']:
    ensure  => installed
  # , require => [ Apt::Ppa["ppa:ondrej/php5"] ]
  }
}
