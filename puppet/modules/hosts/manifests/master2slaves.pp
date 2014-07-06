# The master configuration for the hosts when connecting to the slaves
define hosts::master2slaves($hadoopClusterSize, $baseIp) {

  resources { 'host':
    purge => true
  }

  host { 'add master':
    name  => 'master',
    ip    => "${baseIp}0"
  }

  hosts::addslaves { "add slave-${hadoopClusterSize}":
    count => $hadoopClusterSize,
    base  => $baseIp
  }
}