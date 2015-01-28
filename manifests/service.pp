# Private class
class omsa::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'srvadmin-services':
    ensure  => 'running',
    enable  => undef,
    restart => '/opt/dell/srvadmin/sbin/srvadmin-services.sh restart',
    start   => '/opt/dell/srvadmin/sbin/srvadmin-services.sh start && /opt/dell/srvadmin/sbin/srvadmin-services.sh enable',
    status  => '/opt/dell/srvadmin/sbin/srvadmin-services.sh status',
    stop    => '/opt/dell/srvadmin/sbin/srvadmin-services.sh stop && /opt/dell/srvadmin/sbin/srvadmin-services.sh disable',
  }
}
