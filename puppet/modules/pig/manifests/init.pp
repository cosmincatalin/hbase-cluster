# Pig
class pig ($user, $version, $shareFolder) {

  class { 'pig::install':
    user        => $user,
    version     => $version,
    shareFolder => $shareFolder
  }

  class { 'pig::configure':
    user    => $user,
    require => Class['pig::install']
  }

}