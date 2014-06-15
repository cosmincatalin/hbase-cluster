class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'ssh',
    'openssh-client'
  ]
}

class { 'usergroup':
  user    => $user,
  group   => 'hadoop',
  require => Class['packages']
}

class { 'java':
  user    => $user,
  require => Class['usergroup']
}

class { 'hadoop':
  user    => $user,
  version => '2.4.0',
  require => Class['usergroup']
}