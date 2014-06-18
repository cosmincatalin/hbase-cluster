define hosts::master2slaves($nodesNumber, $baseIp) {

  resources { 'host':
    purge => true
  }

  host { 'add localhost':
    name          => 'localhost',
    host_aliases  => 'master',
    ip            => '127.0.0.1'
  }

  hosts::addslaves { "add slave-${nodesNumber}":
    count   => $nodesNumber,
    base    => $baseIp
  }
}