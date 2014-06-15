class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-server'
  ]
}

class { 'usergroup':
  user    => $user,
  group   => 'hadoop',
  require => Class['packages']
}

class { 'master':
  baseIp  => $base_ip
}