# Private class
class omsa::repo {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  anchor { 'omsa::repo::begin': }
  anchor { 'omsa::repo::end': }

  case $::osfamily {
    'RedHat': {
      include omsa::repo::el

      Anchor['omsa::repo::begin']->
      Class['omsa::repo::el']->
      Anchor['omsa::repo::end']
    }
    default: { }
  }
}
