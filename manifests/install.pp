# Private class
class omsa::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $omsa::install_type {
    # All
    'all': {
      $srvadmin_package_name = 'srvadmin-all'
    }
    # Just enough for omreport
    'minimal': {
      $srvadmin_package_name = 'srvadmin-base'
    }
    # Nothing
    default: { }
  }

  package { 'srvadmin':
    ensure => 'present',
    name   => $srvadmin_package_name,
  }

  if $omsa::install_firmware_tools {
    package { 'dell_ft_install':
      ensure  => 'present',
      require => Package['srvadmin'],
    }
  }

}
