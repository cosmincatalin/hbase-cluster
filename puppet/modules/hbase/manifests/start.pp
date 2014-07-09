# Starts Hadoop related services
class hbase::start($user, $isMaster) {

  if $isMaster {
    # Can be moved to its own virtual machine
    exec { 'start jobhistory':
      command => "./bin/start-hbase.sh",
      user    => $user,
      path  => '/bin:/usr/bin:/sbin',
      cwd     => "/home/${user}/hbase"
    }
  }

}