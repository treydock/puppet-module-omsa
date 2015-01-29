# Class: omsa: See README.md for documentation
class omsa (
  $use_mirror             = true,
  $indep_baseurl          = $omsa::params::indep_baseurl,
  $indep_mirrorlist       = $omsa::params::indep_mirrorlist,
  $hardware_baseurl       = $omsa::params::hardware_baseurl,
  $hardware_mirrorlist    = $omsa::params::hardware_mirrorlist,
  $enable_hardware_repo   = true,
  $dell_gpgkey            = $omsa::params::dell_gpgkey,
  $libsmbios_gpgkey       = $omsa::params::libsmbios_gpgkey,
  $install_type           = 'all',
  $install_firmware_tools = true,
) inherits omsa::params {

  validate_bool($use_mirror, $enable_hardware_repo, $install_firmware_tools)
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
