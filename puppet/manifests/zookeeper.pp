class { 'packages':
  packages  => [
    'vim'
  ]
}

identity::user::add { "Add user ${user}":
  user  => $user,
  group => 'zoo'
}

hosts::zookeepers { 'add zookeepers ips':
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  baseIp                => $base_ip
}

class { 'java':
  user        => $user,
  shareFolder => $share_path,
  require     => Identity::User::Add["Add user ${user}"]
}

class { 'zookeeper':
  user                  => $user,
  version               => $zookeeper_version,
  serverId              => $server_id,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  shareFolder           => $share_path,
  require               => [
    Class['java'],
    Identity::User::Add["Add user ${user}"],
    Hosts::Zookeepers['add zookeepers ips']
  ]
}