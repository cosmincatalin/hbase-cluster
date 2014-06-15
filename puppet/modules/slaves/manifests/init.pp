class slaves($nodesNumber, $baseIp) {
  resources { 'host':
    purge => true
  }

  addslaves { "add slave-${nodesNumber}":
    count   => $nodesNumber,
    base    => $baseIp
  }
}