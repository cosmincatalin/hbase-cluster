# The master configuration for the hosts when connecting to the slaves
define hosts::master2slaves($hadoopClusterSize, $hadoopBaseIp, $zookeeperEnsembleSize, $zookeeperBaseIp) {

  resources { 'host':
    purge => true
  }

  host { 'add master':
    name  => 'master',
    ip    => "${hadoopBaseIp}0"
  }

  hosts::addslaves { "add slave-${hadoopClusterSize}":
    count => $hadoopClusterSize,
    base  => $hadoopBaseIp
  }

  hosts::addzookeepers { "add zookeeper-${zookeeperEnsembleSize}":
    count => $zookeeperEnsembleSize,
    base  => $zookeeperBaseIp
  }
}