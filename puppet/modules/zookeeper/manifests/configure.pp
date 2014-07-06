# Configures a Zookeeper server. All nodes are born equal from the point
# of view of the configuration.
class zookeeper::configure($user, $serverId, $zookeeperEnsembleSize) {

  # Ensure a specific folder structure
  file { "/home/${user}/zookeeper/data":
    ensure  => 'directory',
    owner   => $user
  }

  file { "/home/${user}/zookeeper/data/myid":
    owner   => $user,
    require => File["/home/${user}/zookeeper/data"],
    content => "${serverId}"
  }

  file { "/home/${user}/zookeeper/conf/zoo.cfg":
    path    => "/home/${user}/zookeeper/conf/zoo.cfg",
    owner   => $user,
    group   => 'zoo',
    mode    => '0755',
    content => template('zookeeper/zoo.cfg.erb')
  }

}