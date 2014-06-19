# Basic wrapper for installing packages after an initial update.
# If no packages are specified, it just updates the aptitude repos
class packages($packages) {

  Exec {
    path  => '/bin:/usr/bin',
    user  => 'root'
  }

  exec { 'initial update':
    command => 'apt-get update',
    user    => 'root'
  }

  package { $packages:
    ensure  => 'installed',
    require => Exec['initial update']
  }

}