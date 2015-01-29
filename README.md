# puppet-module-omsa

[![Build Status](https://travis-ci.org/treydock/puppet-module-omsa.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-omsa)

Installs Dell OMSA

## Usage

### omsa

TODO

## Reference

### Classes

#### Public classes

* `omsa`: Manage the OMSA repository, packages and service

#### Private classes

* `omsa::repo`: Includes the OS specific repo class
* `omsa::repo::el`: Manages the OMSA yum repositories and plugin package
* `omsa::install`: Installs necessary packages
* `omsa::service`: Manages the srvadmin-services.sh service
* `omsa::params`: Sets default values based on the `osfamily` and `operatingsystemrelease` facts.

### Parameters

#### omsa

TODO

#### omsa::params

TODO

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

* Facts specific to Dell, similar to those added by yum plugin
