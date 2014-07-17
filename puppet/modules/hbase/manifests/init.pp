# Base class for coordinating setting up Hadoop on a node
class hbase ($user, $isMaster, $version, $shareFolder, $zookeeperEnsembleSize, $hadoopClusterSize) {

  $hbaseIsNotRunning = ! ( $::hmaster_running == 'true'  )

  if $hbaseIsNotRunning {

    class { 'hbase::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

    class { 'hbase::configure':
      user                  => $user,
      zookeeperEnsembleSize => $zookeeperEnsembleSize,
      hadoopClusterSize     => $hadoopClusterSize,
      require               => Class['hbase::install']
    }

    class { 'hbase::start':
      user      => $user,
      isMaster  => $isMaster,
      require   => Class['hbase::configure']
    }

  }

}