# The hosts configuration for a slave that will try to connect to a master
define hosts::slave2master(
    $hadoopBaseIp,
    $zookeeperEnsembleSize,
    $zookeeperBaseIp,
    $hadoopClusterSize
) {

  resources { 'host':
    purge => true
  }

  host { 'add master on slave':
    name  => 'master',
    ip    => "${hadoopBaseIp}0"
  }

  hosts::addzookeepers { "add zookeeper-${zookeeperEnsembleSize}":
    count => $zookeeperEnsembleSize,
    base  => $zookeeperBaseIp
  }

  hosts::addslaves { "add slaves-${hadoopClusterSize}":
    count => $hadoopClusterSize,
    base  => $hadoopBaseIp
  }
}