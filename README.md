# upkeep

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What upkeep does and why it is useful](#module-description)
3. [Setup - The basics of getting started with upkeep](#setup)
    * [What upkeep affects](#what-upkeep-affects)
    * [Beginning with upkeep](#beginning-with-upkeep)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what upkeep is doing and how](#reference)
5. [Limitations](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

Provides a unified way to roll out package updates to an entire managed cluster.

## Module Description

When Puppet in managing packages on more nodes than you care to log into and update manually, you need a way for Puppet to uniformly and safely update these packages.  This module is intended to do just that by working with the system's package manager.  A state file is stored locally on the system and when puppet updates this file a cascade of actions will update the desired packages on the system.

## Setup

### What upkeep affects

* Packages maintained by the system's package manager.
* State files stored on the system keeping track of updates.

### Beginning with upkeep

To put in place all needed files but not have anything upgrade:

```puppet
include upkeep
```

## Usage

In order to do a safe package upgrade (one that won't remove packages) of all upgradeable packages you can update the `timestamp` parameter here:

```puppet
upkeep::safe_upgrade {
  timestamp => '2015-06-02_14:38:06',
}
```

While you can pass what you like to the `timestamp` parameter and puppet will preform the upgrade, it is in your best interest to pass a uniform and current datetime for your future reference.

If a more extensive upgrade (i.e. one that potentially could remove packages or have unforeseen failures) has been checked and needs to be rolled out:

```puppet
upkeep::dist_upgrade {
  timestamp => '2015-06-02_14:38:06',
}
```

## Reference

## Limitations

This module is only compatible with RedHat and Debian based systems.

## Development

This module is open to collaboration and feedback.
