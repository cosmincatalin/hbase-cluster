# The hosts configuration for a slave that will try to connect to a master
define hosts::slave2master($baseIp) {

  resources { 'host':
    purge => true
  }

  host { 'add master on slave':
    name  => 'master',
    ip    => "${baseIp}0"
  }
}