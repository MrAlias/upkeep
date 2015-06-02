# == Class: upkeep
#
# Provides a unified way to roll out package updates.
#
# This module will update the system two ways: safely and fully.  Fully
# updating the system is different in that it could delete unspecified
# packages. Both ways of updating are managed by files containing date/time
# stamps (`full_timestamp` and `safe_timestamp`).  In practice these
# date/time stamps can be anything you want, the upgrade will happen whenever
# they changes.  However, future you will thank past you when you use a
# date/time stamp, as this helps keep a record of when packages were upgraded
# by upkeep.
#
# === Parameters
#
# [*state_dir*]
#   Absolute path to where the state files are stored.
#
# [*full_upgrade_cmd*]
#   Command that does a full package upgrade.
#
# [*full_timestamp*]
#   A date/time specifying up to what point packages older then should
#   be fully updated regardless of consequences.  If set to an empty string
#   no update will happen.
#
#   Defaults to an empty string.
#
# [*safe_upgrade_cmd*]
#   Command that does a safe package upgrade.
#
# [*safe_timestamp*]
#   A date/time specifying up to what point packages older then should
#   be safely updated.  If set to an empty string no update will happen.
#
#   Defaults to an empty string.
#
# [*manage_rkhunter*]
#   If rkhunter is installed on the system it will likely complain if
#   packages are upgraded with out it knowing about it.  This parameter
#   specifies if rkhunter should be notified up package upgrades by
#   having it run `rkhunter --propupd`.
#
# [*rkhunter*]
#   Absolute path of the rkhunter executable to run if rkhunter is updated.
#
# === Examples
#
# Setup the upkeep module needed file structure:
#
#  include upkeep
#
# Safely update packages prior to 2015-06-02_14:38:06.
#
#  class { 'upkeep':
#    safe_timestamp => '2015-06-02_14:38:06',
#  }
#
# === Authors
#
# Tyler Yahn <codingalias@gmail.com>
#
# === Copyright
#
# Copyright 2015 Tyler Yahn
#
class upkeep (
  $state_dir        = hiera("${module_name}::state_dir", '/opt/upkeep'),
  $full_upgrade_cmd = hiera("${module_name}::full_upgrade_cmd", $upkeep::params::full_upgrade_cmd),
  $full_timestamp   = hiera("${module_name}::full_timestamp", ""),
  $safe_upgrade_cmd = hiera("${module_name}::safe_upgrade_cmd", $upkeep::params::safe_upgrade_cmd),
  $safe_timestamp   = hiera("${module_name}::safe_timestamp", ""),
  $manage_rkhunter  = hiera("${module_name}::manage_rkhunter", false),
  $rkhunter         = hiera("${module_name}::rkhunter", $upkeep::params::rkhunter),
) inherits upkeep::params {
  validate_absolute_path($state_dir)
  validate_absolute_path($rkhunter)
  validate_bool($manage_rkhunter)
  validate_string($full_upgrade_cmd)
  validate_string($full_timestamp)
  validate_string($safe_upgrade_cmd)
  validate_string($safe_timestamp)

  exec { 'Make state file directory':
    command => "mkdir -p ${state_dir}",
    path    => ['/bin', '/usr/bin'],
    creates => $state_dir,
  }

  file { 'Ensure state directory correct':
    ensure    => directory,
    path      => $state_dir,
    owner     => 'root',
    group     => 'root',
    mode      => '0750',
    subscribe => Exec['Make state file directory'],
  }

  file { 'Full Upgrade Timestamp':
    ensure  => file,
    path    => "${state_dir}/full-upgrade.timestamp",
    content => $full_timestamp,
    require => File['Ensure state directory correct'],
  }

  file { 'Safe Upgrade Timestamp':
    ensure  => file,
    path    => "${state_dir}/safe-upgrade.timestamp",
    content => $safe_timestamp,
    require => File['Ensure state directory correct'],
  }

  if $full_timestamp {
    exec { 'Full Upgrade':
      command     => $full_upgrade_cmd,
      refreshonly => true,
      subscribe   => File['Full Upgrade Timestamp'],
    }
  }

  if $safe_timestamp {
    exec { 'Safe Upgrade':
      command     => $safe_upgrade_cmd,
      refreshonly => true,
      subscribe   => File['Safe Upgrade Timestamp'],
    }
  }

  if $manage_rkhunter {
    exec { 'Notify rkhunter of safe upgrade':
      command     => "${rkhunter} --propupd",
      refreshonly => true,
      timeout     => 3600,
      subscribe   => [
        Exec['Full Upgrade'],
        Exec['Safe Upgrade'],
        ],
    }
  }
}
