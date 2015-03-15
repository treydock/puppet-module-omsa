# == Class: omsa::params
#
# The omsa configuration settings.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class omsa::params (
  $repo_base   = 'http://linux.dell.com/repo/hardware/latest',
  $gpgkey_base = 'http://linux.dell.com/repo/hardware/latest',
) {

  if $::manufacturer =~ /Dell/ {
    if $::architecture != 'x86_64' {
      fail("Unsupported architecture: ${::architecture}, module ${module_name} only supports x86_64.")
    }

    case $::osfamily {
      'RedHat': {
        case $::operatingsystemrelease {
          /^5/: {
            $os_bit = 'rh50_64'
          }
          /^6/: {
            $os_bit = 'rh60_64'
          }
          /^7/: {
            $os_bit = 'rh70_64'
          }
          default: {
            fail("Unsupported operatingsystemrelease: ${::operatingsystemrelease}, module ${module_name} only supports 5.x, 6.x, and 7.x")
          }
        }
      }

      default: {
        fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat.")
      }
    }
  }

  $indep_baseurl       = "${repo_base}/platform_independent/${os_bit}/"
  $indep_mirrorlist    = "${repo_base}/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&native=1&dellsysidpluginver=\$dellsysidpluginver"
  $hardware_baseurl    = "${repo_base}/system.ven_\$sys_ven_id.dev_\$sys_dev_id/${os_bit}"
  $hardware_mirrorlist = "${repo_base}/mirrors.cgi?osname=el\$releasever&basearch=\$basearch&native=1&sys_ven_id=\$sys_ven_id&sys_dev_id=\$sys_dev_id&dellsysidpluginver=\$dellsysidpluginver"
  $dell_gpgkey         = "${gpgkey_base}/RPM-GPG-KEY-dell"
  $libsmbios_gpgkey    = "${gpgkey_base}/RPM-GPG-KEY-libsmbios"
}