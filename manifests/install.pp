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
      package { 'srvadmin-omcommon':
        ensure => 'present',
      }->
      package { 'srvadmin-omacore':
        ensure => 'present',
      }
    }
    # Nothing
    default: { }
  }
}
