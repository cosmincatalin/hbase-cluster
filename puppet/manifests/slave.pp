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

hosts::slave2master { 'add master ip':
  hadoopBaseIp          => $hadoop_base_ip,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  zookeeperBaseIp       => $zookeeper_base_ip
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
  user    => $user,
  require => Identity::User::Add["Add user ${user}"]
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

class { 'hbase':
  user                  => $user,
  isMaster              => false,
  version               => $hbase_version,
  shareFolder           => $share_path,
  hadoopClusterSize     => $hadoop_cluster_size,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  require               => Class['hadoop']
}