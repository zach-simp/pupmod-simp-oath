[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/oath.svg)](https://forge.puppetlabs.com/simp/oath)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/oath.svg)](https://forge.puppetlabs.com/simp/oath)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-oath.svg)](https://travis-ci.org/simp/pupmod-simp-oath)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with oath](#setup)
    * [What oath affects](#what-oath-affects)
    * [Beginning with oath](#beginning-with-oath)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
    * [Acceptance Tests - Beaker env variables](#acceptance-tests)

## Description

By default, this module will only install oathtool, a command line utility for
generating one-time passwords. 

Optionally, this module will install the pam_oath and liboath packages from epel
and configure them. In this case, this module will manage the configurtion for
these packages, including users, keys and exclusions.

### This is a SIMP module

This module is a component of the [System Integrity Management
Platform](https://simp-project.com), a
compliance-management framework built on Puppet.

If you find any issues, they may be submitted to our [bug
tracker](https://simp-project.atlassian.net/).

This module is optimally designed for use within a larger SIMP ecosystem, but
it can be used independently:

 * When included within the SIMP ecosystem, security compliance settings will
   be managed from the Puppet server.
 * If used independently, all SIMP-managed security subsystems are disabled by
   default and must be explicitly opted into by administrators.  Please review
   the parameters in
   [`simp/simp_options`](https://github.com/simp/pupmod-simp-simp_options) for
   details.

## Setup

### What oath affects

If configured to install pam_oath, will install the following packages
 
 * `pam_oath`
    Will add `/usr/lib64/security/pam_oath.so`
 * `liboath`
 * `pam` (A dependency of pam_oath)


Will manage files in `/etc/liboath` 

**WARNING:** While this module will not edit the pam stack, it will manage the
users and keys _required_ for `pam_oath.so` module function. If the pam stack is
modified to utilize this module, only users in `/etc/liboath/users.oath` or
those who fall under an exclude will be able to authenticate.


### Beginning with oath

```puppet
include 'oath'
```

## Usage

```puppet
include 'oath'
```
For anything greater than simple installation of oathtool, either
`simp_options::oath` needs to be set to `true` or `oath::pam_oath` needs to be
overriden to true.

A default list of users for which totp keys are configured is defined in
`data/common.yaml` for the module. More details about this can be found in the
documentation of `manifests/config.pp`. This can be modified in place or
overriden in puppet or hiera. 

## Limitations

Currently, while the pam_oath package supports HOTP as well as TOTP, this module
only supports TOTP configuration. 

SIMP Puppet modules are generally intended for use on Red Hat Enterprise Linux
and compatible distributions, such as CentOS. Please see the
[`metadata.json` file](./metadata.json) for the most up-to-date list of
supported operating systems, Puppet versions, and module dependencies.

## Development

Please read our [Contribution Guide](http://simp-doc.readthedocs.io/en/stable/contributors_guide/index.html).

### Acceptance tests
As use of this module by itself should not affect the operation of a system,
this module contains only spec tests.
