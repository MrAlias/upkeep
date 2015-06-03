# upkeep

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What upkeep does and why it is useful](#module-description)
3. [Setup - The basics of getting started with upkeep](#setup)
    * [What upkeep affects](#what-upkeep-affects)
    * [Beginning with upkeep](#beginning-with-upkeep)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what upkeep is doing and how](#reference)
    * [Private Classes](#private-classes)
    * [Public Classes](#public-classes)
6. [Limitations](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

Provides a unified way to roll out package updates to an entire Puppet managed cluster.

## Module Description

When Puppet in managing packages on more nodes than you care to log into and update manually, you need a way for Puppet to uniformly and safely update these packages.  This module is intended to do just that by working with the system's package manager.

Updates are done in two ways: safely and fully.  Fully updating the system is different in that it could delete unspecified packages. Both ways of updating are managed by state files containing date/time stamps (`full_timestamp` and `safe_timestamp`).  In practice these date/time stamps can be anything you want, the upgrade will happen whenever they changes.  However, future you will thank past you when you use a date/time stamp, as this helps keep a record of when packages were upgraded by upkeep.

## Setup

### What upkeep affects

* Packages maintained by the system's package manager.
* State files stored on the system keeping track of updates.

### Beginning with upkeep

To put in place all needed files but not have anything update:

```puppet
include upkeep
```

## Usage

In order to do a safe package upgrade, update the `safe_timestamp` parameter here:

```puppet
class { 'upkeep':
  safe_timestamp => '2015-06-02_14:38:06',
}
```

While you can pass what you like to the `timestamp` parameter and puppet will preform the upgrade, it is in your best interest to pass a uniform and current datetime for your future reference.

If a more extensive upgrade (i.e. one that potentially could remove packages or have unforeseen failures), update the `full_timestamp`:

```puppet
class { 'upkeep':
  full_timestamp => '2015-06-02_14:38:06',
}
```

If you're not on a RedHat or Debian based systems using `yum` or `aptitude` you could still use upkeep to manage package updates.  You will need to provide update commands and possibly a place to store state files.  An example of doing so with an Archlinux system using `pacman` might look somethings like:

```puppet
class { 'upkeep':
  safe_upgrade_cmd => 'pacman -Syyu',
  state_dir        => '/etc/upkeep',
  safe_timestamp   => '2015-06-02_14:38:06',
}
```

Keep in mind that this is experimental and not actively tested.  If there are issues please [report](https://github.com/MrAlias/upkeep/issues) them.

## Reference

### Private Classes

#### upkeep::params

This defines operating system specific values to parameters and should not be directly used.

### Public Classes

#### upkeep

Provides functionality for the unified way of rolling out package updates.

##### `upkeep::state_dir`

  Absolute path to where the state files are stored.

##### `upkeep::full_upgrade_cmd`

  Command that does a full package upgrade.

##### `upkeep::full_timestamp`

  A date/time specifying up to what point packages older then should be fully updated regardless of consequences.  If set to an empty string no update will happen.

  Defaults to an empty string.

##### `upkeep::safe_upgrade_cmd`

  Command that does a safe package upgrade.

##### `upkeep::safe_timestamp`

  A date/time specifying up to what point packages older then should be safely updated.  If set to an empty string no update will happen.

  Defaults to an empty string.

##### `upkeep::manage_rkhunter`

  If rkhunter is installed on the system it will likely complain if packages are upgraded without it knowing about them.  This parameter specifies if rkhunter should be updated by runing `rkhunter --propupd`.

##### `upkeep::rkhunter`

  Absolute path of the rkhunter executable to run if rkhunter is updated.

## Limitations

This module cuttently only supports RedHat and Debian based systems using `yum` and `aptitude` package managers.

The module is built with the intent to support other operating systems with a bit of customization.  This likely means that you will have to provide update commands and possibly a place to store state files.

*Caveat Emptor*: this module has only been tested on the mentioned supported systems.

## Development

This module is open to collaboration and feedback.

Guide lines for both:

* Keep it clean
* Keep it concise
* Have an open mind
