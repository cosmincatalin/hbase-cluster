# Base class for installing Phoenix
class phoenix ($user, $version, $shareFolder) {

  class { 'phoenix::install':
    user        => $user,
    version     => $version,
    shareFolder => $shareFolder
  }

  class { 'phoenix::configure':
    user    => $user,
    require => Class['phoenix::install']
  }
}