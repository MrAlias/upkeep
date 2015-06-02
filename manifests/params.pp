# == Class: upkeep::params
#
# Private class defining OS specific variables.
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
# === Copyright
#
# Copyright 2015 Tyler Yahn
#
class upkeep::params {
  $rkhunter = '/usr/bin/rkhunter'

  case $::osfamily {
    'RedHat': {
      $full_upgrade_cmd = '/usr/bin/yum distro-sync full -y'
      $safe_upgrade_cmd = '/usr/bin/yum upgrade -y'
    }
    'Debian': {
      $full_upgrade_cmd = '/usr/bin/aptitude update && /usr/bin/aptitude dist-upgrade -y'
      $safe_upgrade_cmd = '/usr/bin/aptitude update && /usr/bin/aptitude upgrade -y'
    }
    default: {
      fail("The ${module_name} module does not support an ${::osfamily} based system.")
    }
  }
}
