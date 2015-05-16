# Base class for coordinating setting up Spark on a node
class spark ($user, $version, $shareFolder, $clusterSize) {

  class { 'spark::install':
    user        => $user,
    version     => $version,
    shareFolder => $shareFolder
  }

  class { 'spark::configure':
    user        => $user,
    clusterSize => $clusterSize,
    require     => Class['spark::install']
  }

}