# The zookeper configuration for the hosts to connect to each other
define hosts::zookeepers($nodesNumber, $baseIp) {

  resources { 'host':
    purge => true
  }

  hosts::addzookeepers { "add zookeper-${nodesNumber}":
    count   => $nodesNumber,
    base    => $baseIp
  }
}