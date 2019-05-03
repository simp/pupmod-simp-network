[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/network.svg)](https://forge.puppetlabs.com/simp/network)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/network.svg)](https://forge.puppetlabs.com/simp/network)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-network.svg)](https://travis-ci.org/simp/pupmod-simp-network)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with simp-network](#setup)
    * [What simp-network affects](#what-simp-network-affects)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Basic Usage](#basic-usage)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
      * [Acceptance Tests - Beaker env variables](#acceptance-tests)

## Overview

This module assists users in managing network interfaces on their system.

## This is a SIMP module
This module is a component of the [System Integrity Management Platform](https://simp-project.com)

If you find any issues, please submit them via [JIRA](https://simp-project.atlassian.net/).

Please read our [Contribution Guide] (https://simp.readthedocs.io/en/stable/contributors_guide/index.html).

## Module Description

This module targets the configuration of network interfaces on supported
operating systems.

## Setup

### What simp-network affects

This module affects the creation and management of various types of network
devices on RHEL-compatible operating systems.

## Usage

### Basic Usage

#### Set global networking parameters

```
include network::global
```

#### Manage a network interface

```
network::eth { 'eth0':
  macaddr => $facts['macaddress_eth0']
}
```

#### Set up a bridge bound to an interface

```
network::eth { 'eth0':
  bridge  => 'br0',
  macaddr => $facts['macaddress_eth0']
}

network::eth { 'br0':
  net_type  => 'Bridge',
  onboot    => true,
  macaddr   => $facts['macaddress_eth0'],
  ipaddr    => pick($facts['ipaddress_eth0'], $facts['ipaddress_br0']),
  gateway   => $facts['defaultgateway'],
  broadcase => $facts['netmask_eth0'],
  require   => Network::Eth['eth0']
}
```

# Limitations

This module is designed to work only with RHEL-compatible operating systems.

## Development

Please read our [Contribution Guide] (https://simp.readthedocs.io/en/stable/contributors_guide/index.html).

### Unit tests

Unit tests, written in ``rspec-puppet`` can be run by calling:

```shell
bundle exec rake spec
```

### Acceptance tests

To run the system tests, you need [Vagrant](https://www.vagrantup.com/) installed. Then, run:

```shell
bundle exec rake beaker:suites
```

Some environment variables may be useful:

```shell
BEAKER_debug=true
BEAKER_provision=no
BEAKER_destroy=no
BEAKER_use_fixtures_dir_for_modules=yes
```

* `BEAKER_debug`: show the commands being run on the STU and their output.
* `BEAKER_destroy=no`: prevent the machine destruction after the tests finish so you can inspect the state.
* `BEAKER_provision=no`: prevent the machine from being recreated. This can save a lot of time while you're writing the tests.
* `BEAKER_use_fixtures_dir_for_modules=yes`: cause all module dependencies to be loaded from the `spec/fixtures/modules` directory, based on the contents of `.fixtures.yml`.  The contents of this directory are usually populated by `bundle exec rake spec_prep`.  This can be used to run acceptance tests to run on isolated networks.
