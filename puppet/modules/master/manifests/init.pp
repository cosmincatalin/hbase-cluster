class master($baseIp) {
  resources { 'host':
    purge => true
  }

  host { 'add localhost on slave':
    name  => 'localhost',
    ip    => '127.0.0.1'
  }

  host { 'add master on slave':
    name  => 'master',
    ip    => "${baseIp}0"
  }
}