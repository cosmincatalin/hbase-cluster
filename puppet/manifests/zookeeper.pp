class { 'packages':
  packages  => [
    'vim'
  ]
}

identity::user::add { "Add user ${user}":
  user        => $user,
  group       => 'zoo'
}

hosts::zookeepers { 'add zookeepers ips':
  nodesNumber => $cluster_size,
  baseIp      => $base_ip
}

class { 'java':
  user    => $user,
  require => Identity::User::Add["Add user ${user}"]
}

class { 'zookeeper':
  user        => $user,
  version     => $zookeeper_version,
  serverId    => $server_id,
  clusterSize => $cluster_size,
  shareFolder => $share_path,
  require     => [
    Class['java'],
    Identity::User::Add["Add user ${user}"],
    Hosts::Zookeepers['add zookeepers ips']
  ]
}