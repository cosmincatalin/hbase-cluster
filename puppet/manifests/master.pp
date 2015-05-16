class { 'packages':
  packages  => [
    'vim',
    'libaugeas-ruby',
    'augeas-tools',
    'openssh-client',
    'scala'
  ]
}

identity::user::add { "Add user ${user}":
  user  => $user,
  group => 'hadoop'
}

hosts::master2slaves { 'add slaves ips':
  hadoopClusterSize     => $hadoop_cluster_size,
  hadoopBaseIp          => $hadoop_base_ip,
  zookeeperEnsembleSize => $zookeeper_ensemble_size,
  zookeeperBaseIp       => $zookeeper_base_ip
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
  shareDir    => $share_path,
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
  user        => $user,
  shareFolder => $share_path,
  require     => Identity::User::Add["Add user ${user}"]
}

class { 'hadoop':
  user        => $user,
  isMaster    => true,
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

class { 'swap':
  sizeInMb => 1000
}

class { 'hbase':
  user                  => $user,
  isMaster              => true,
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

class { 'sqoop':
  user        => $user,
  version     => $sqoop_version,
  shareFolder => $share_path,
  require     => Class['hbase']
}

class { 'hive':
  user        => $user,
  version     => $hive_version,
  shareFolder => $share_path,
  require     => Class['hbase']
}

class { 'pig':
  user        => $user,
  version     => $pig_version,
  shareFolder => $share_path,
  require     => Class['hbase']
}