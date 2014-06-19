class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-server'
  ]
}

identity::user::add { "Add user ${user}":
  user    => $user,
  group   => 'hadoop'
}

hosts::slave2master { 'add master ip':
  baseIp      => $base_ip
}

# @todo: Refactor the dependencies so that this doesn't get called
# just so that the ssh file structure gets created
ssh::key::generate{ 'slave key':
  user  => $user,
  group => 'hadoop'
}

ssh::key::import{ 'import master key to slave':
  user        => $user,
  shareDir    => $share_path,
  key         => $shared_key,
  require     => Ssh::Key::Generate['slave key']
}

ssh::config{ 'login for slaves':
  user      => $user,
  host      => 'master',
  require   => Identity::User::Add["Add user ${user}"]
}

class { 'java':
  user    => $user,
  require => Identity::User::Add["Add user ${user}"]
}

class { 'hadoop':
  user      => $user,
  isMaster  => false,
  version   => '2.4.0',
  require   => [
    Class['java'],
    Identity::User::Add["Add user ${user}"]
  ]
}