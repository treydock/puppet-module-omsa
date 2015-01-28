# Private class
class omsa::repo::el {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $omsa::use_mirror {
    $indep_baseurl    = 'absent'
    $indep_mirrorlist = $omsa::indep_mirrorlist
  } else {
    $indep_baseurl    = $omsa::indep_baseurl
    $indep_mirrorlist = 'absent'
  }

  yumrepo { 'dell-omsa-indep':
    descr          => 'Dell OMSA repository - Hardware independent',
    baseurl        => $indep_baseurl,
    mirrorlist     => $indep_mirrorlist,
    enabled        => '1',
    gpgcheck       => '1',
    gpgkey         => "${omsa::dell_gpgkey} ${omsa::libsmbios_gpgkey}",
    failovermethod => 'priority',
    
  }

  package { 'yum-dellsysid':
    ensure  => 'present',
    require => Yumrepo['dell-omsa-indep'],
  }
}
