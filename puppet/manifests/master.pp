class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-client'
  ]
}

identity::user::add { "Add user ${user}":
  user    => $user,
  group   => 'hadoop'
}

hosts::master2slaves { 'add slaves ips':
  nodesNumber => $nodes_number,
  baseIp      => $base_ip
}

ssh::key::generate{ 'generate master key':
  user    => $user,
  group   => 'hadoop',
  require => Identity::User::Add["Add user ${user}"]
}

ssh::key::export{ 'copy to shared folder':
  user        => $user,
  shareFolder => $share_path,
  key         => $shared_key,
  require     => Ssh::Key::Generate['generate master key']
}

ssh::key::import{ 'import master key to itself':
  user        => $user,
  shareFolder => $share_path,
  key         => $shared_key,
  require     => Ssh::Key::Export['copy to shared folder']
}

ssh::config{ 'login for slaves':
  user      => $user,
  host      => 'slave-*',
  require   => Ssh::Key::Generate['generate master key']
}

ssh::config{ 'login for master':
  user      => $user,
  host      => 'master',
  require   => Ssh::Key::Generate['generate master key']
}

class { 'java':
  user    => $user,
  require => Identity::User::Add["Add user ${user}"]
}

class { 'hadoop':
  user      => $user,
  isMaster  => true,
  version   => '2.4.0',
  require   => [
    Class['java'],
    Identity::User::Add["Add user ${user}"]
  ]
}