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

# Needs indempotence
class { 'slaves':
  nodesNumber => $nodes_number,
  baseIp      => $base_ip
}

# Needs indempotence
class { 'sharekey':
  user        => $user,
  group       => $group,
  shareFolder => $share_path,
  key         => $shared_key,
  require => Class['usergroup']
}

# class { 'java':
#   user    => $user,
#   require => Class['usergroup']
# }

# Needs indempotence
# class { 'hadoop':
#   user    => $user,
#   version => '2.4.0',
#   require => Class['usergroup']
# }