class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-client'
  ]
}

class { 'usergroup':
  user    => $user,
  group   => 'hadoop',
  require => Class['packages']
}

class { 'slaves':
  nodesNumber => $nodes_number,
  baseIp      => $base_ip
}

class { 'sharekey':
  user        => $user,
  group       => $group,
  shareFolder => $share_path,
  key         => $shared_key,
  require => Class['usergroup']
}

class { 'java':
  user    => $user,
  require => Class['usergroup']
}

class { 'hadoop':
  user      => $user,
  isMaster  => true,
  version   => '2.4.0',
  require   => Class['usergroup']
}