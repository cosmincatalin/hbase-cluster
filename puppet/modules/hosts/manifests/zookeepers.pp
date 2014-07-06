# The zookeper configuration for the hosts to connect to each other
define hosts::zookeepers($zookeeperEnsembleSize, $baseIp) {

  resources { 'host':
    purge => true
  }

  hosts::addzookeepers { "add zookeper-${zookeeperEnsembleSize}":
    count => $zookeeperEnsembleSize,
    base  => $baseIp
  }
}