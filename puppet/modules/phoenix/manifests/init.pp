# Base class for installing Phoenix
class phoenix ($user, $version, $shareFolder) {

  class { 'phoenix::install':
    user        => $user,
    version     => $version,
    shareFolder => $shareFolder
  }
}