# Hive
class hive ($user, $version, $shareFolder) {

  class { 'hive::install':
    user        => $user,
    version     => $version,
    shareFolder => $shareFolder
  }

  class { 'hive::configure':
    user    => $user,
    require => Class['hive::install']
  }

}