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
    ensure  => "installed",
    require => Exec['initial update']
  }

}