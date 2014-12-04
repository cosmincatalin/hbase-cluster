# Base class for coordinating setting up Zookeeper in an ensemble
class zookeeper ($user, $version, $serverId, $zookeeperEnsembleSize, $shareFolder) {

  $zookeeperIsNotRunning = $::quorum_running != 'true'

  if  $zookeeperIsNotRunning {
    class { 'zookeeper::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

    class { 'zookeeper::configure':
      user                  => $user,
      serverId              => $serverId,
      zookeeperEnsembleSize => $zookeeperEnsembleSize,
      require               => Class['zookeeper::install']
    }

    class { 'zookeeper::start':
      user    => $user,
      require => Class['zookeeper::configure']
    }
  }
}
