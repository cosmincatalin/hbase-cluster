# Base class for coordinating setting up Hadoop on a node
class hadoop ($user, $isMaster, $version, $shareFolder) {

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