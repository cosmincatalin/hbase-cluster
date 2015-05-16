class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-server'
  ]
}

identity::user::add { "Add user ${user}":
  user  => $user,
  group => 'hadoop'
}

hosts::slave2master { 'add ips':
  hadoopBaseIp          => $hadoop_base_ip,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  zookeeperBaseIp       => $zookeeper_base_ip,
  hadoopClusterSize     => $hadoop_cluster_size
}

# @todo: Refactor the dependencies so that this doesn't get called
# just so that the ssh file structure gets created
ssh::key::generate{ 'slave key':
  user  => $user,
  group => 'hadoop'
}

ssh::key::import{ 'import master key to slave':
  user      => $user,
  shareDir  => $share_path,
  key       => $shared_key,
  require   => Ssh::Key::Generate['slave key']
}

ssh::config{ 'login for slaves':
  user      => $user,
  host      => 'master',
  require   => Identity::User::Add["Add user ${user}"]
}

class { 'java':
  user        => $user,
  shareFolder => $share_path,
  require     => Identity::User::Add["Add user ${user}"]
}

class { 'hadoop':
  user        => $user,
  isMaster    => false,
  version     => $hadoop_version,
  shareFolder => $share_path,
  require     => [
    Class['java'],
    Identity::User::Add["Add user ${user}"]
  ]
}

class { 'spark':
  user        => $user,
  version     => $spark_version,
  shareFolder => $share_path,
  clusterSize => $hadoop_cluster_size,
  require     => Class['hadoop']
}

class { 'hbase':
  user                  => $user,
  isMaster              => false,
  version               => $hbase_version,
  shareFolder           => $share_path,
  hadoopClusterSize     => $hadoop_cluster_size,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  require               => Class['hadoop']
}

class { 'phoenix':
  user                  => $user,
  version               => $phoenix_version,
  shareFolder           => $share_path,
  require               => Class['hbase']
}