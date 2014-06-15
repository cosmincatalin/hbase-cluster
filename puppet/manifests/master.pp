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

# class { 'java':
#   user    => $user,
#   require => Class['usergroup']
# }

# class { 'hadoop':
#   user    => $user,
#   version => '2.4.0',
#   require => Class['usergroup']
# }