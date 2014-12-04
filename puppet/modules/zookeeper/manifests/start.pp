# Starts a Zookeeper server
class zookeeper::start($user) {

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { 'start zookeeper':
    command => "/home/${user}/zookeeper/bin/zkServer.sh start",
    cwd    => "/home/${user}/zookeeper/bin"
  }

  cron { 'start zookeeper on boot':
    user  => $user,
    special => 'reboot',
    command => "cd /home/${user}/zookeeper/bin && /home/${user}/zookeeper/bin/zkServer.sh start"
  }

}
