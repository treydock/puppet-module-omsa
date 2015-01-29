# Private class
class omsa::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  case $omsa::install_type {
    # All
    'all': {
      package { 'srvadmin-all':
        ensure => 'present',
      }
    }
    # Just enough for omreport
    'minimal': {
      package { 'srvadmin-base':
        ensure => 'present',
      }
      package { 'srvadmin-storageservices':
        ensure => 'present',
      }
    }
    # Nothing
    default: { }
  }

  if $omsa::install_firmware_tools {
    package { 'dell_ft_install':
      ensure  => 'present',
    }
  }

}
