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

  # exec { 'apt-get update':
  #   command => "apt-get update --fix-missing"
  # , require => [ Apt::Ppa["ppa:ondrej/php5"] ]
  # }

  package { 'php5-cli':
    ensure  => installed
  , require => [ Apt::Ppa["ppa:ondrej/php5"] ]
  }

  package { ['php5-xdebug', 'php5-xsl']:
    ensure  => installed
  , require => [ Package["php5-cli"] ]
  }
}
