# Base class for coordinating setting up Hadoop on a node
class zookeeper ($user, $version, $serverId, $clusterSize, $shareFolder) {

  if $::quorum_running == 'true' {
    class { 'zookeeper::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

    class { 'zookeeper::configure':
      user        => $user,
      serverId    => $serverId,
      clusterSize => $clusterSize,
      require     => Class['zookeeper::install']
    }

    class { 'zookeeper::start':
      user      => $user,
      require   => Class['zookeeper::configure']
    }
  }
}