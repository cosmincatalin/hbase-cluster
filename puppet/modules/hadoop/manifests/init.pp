# Base class for coordinating setting up Hadoop on a node
class hadoop ($user, $isMaster, $version, $shareFolder) {

  $hadoopIsNotRunning = ! ( $::resource_manager_running == 'true' or $::node_manager_running == 'true' )

  if $hadoopIsNotRunning {
    class { 'hadoop::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

    class { 'hadoop::configure':
      user      => $user,
      require   => Class['hadoop::install']
    }

    class { 'hadoop::start':
      user      => $user,
      isMaster  => $isMaster,
      require   => Class['hadoop::configure']
    }
  }

}