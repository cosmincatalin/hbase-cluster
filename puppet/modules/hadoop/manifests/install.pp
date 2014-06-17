class hadoop::install($user, $version) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "/apache/hadoop/common/hadoop-${version}/"
  $file = "hadoop-${version}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download hadoop-${version}":
    command => "wget ${protocol}://${domain}${path}${file}",
    cwd     => "/home/${user}/"
  }

  exec { "extract hadoop-${version}":
    command => "tar xvf ${file} && rm ${file}",
    cwd => "/home/${user}",
    require => Exec["download hadoop-${version}"]
  }

  file { "/home/${user}/hadoop":
    ensure => 'link',
    target => "/home/${user}/hadoop-${version}",
    owner => $user,
    require => Exec["extract hadoop-${version}"]
  }

}