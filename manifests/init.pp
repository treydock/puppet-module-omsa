# Class: omsa: See README.md for documentation
class omsa (
  $use_mirror       = true,
  $indep_baseurl    = $omsa::params::indep_baseurl,
  $indep_mirrorlist = $omsa::params::indep_mirrorlist,
  $dell_gpgkey      = $omsa::params::dell_gpgkey,
  $libsmbios_gpgkey = $omsa::params::libsmbios_gpgkey,
  $install_type     = 'all',
) inherits omsa::params {

  validate_bool($use_mirror)
  validate_re($install_type, ['^all$', '^minimal$'])

  case $::manufacturer {
    /Dell/: {
      include omsa::repo
      include omsa::install
      include omsa::service

      anchor { 'omsa::begin': }
      anchor { 'omsa::end': }

      Anchor['omsa::begin']->
      Class['omsa::repo']->
      Class['omsa::install']->
      Class['omsa::service']->
      Anchor['omsa::end']
    }
    # If not Dell, do nothing
    default: { }
  }

}
