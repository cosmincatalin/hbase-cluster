# Base class for coordinating setting up Hadoop on a node
class hadoop ($user, $isMaster, $version) {

  class { 'hadoop::install':
    user      => $user,
    version   => $version
  }

  class { 'hadoop::configure':
    user      => $user,
    require   => Class['hadoop::install']
  }

  class { 'hadoop::start':
    user      => $user,
    require   => Class['hadoop::configure']
  }

}