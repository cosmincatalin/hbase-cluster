# Install Hadoop by downloading it, extracting it and linking it
class zookeeper::install($user, $version) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "/apache/zookeeper/zookeeper-${version}/"
  $file = "zookeeper-${version}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download zookeeper-${version}":
    command   => "wget ${protocol}://${domain}${path}${file}",
    cwd       => "/home/${user}/",
    logoutput => true,
    timeout   => 1800 # 30 minutes `should be more than enough`
  }

  exec { "extract zookeeper-${version}":
    command => "tar xvf ${file} && rm ${file}",
    cwd     => "/home/${user}",
    require => Exec["download zookeeper-${version}"]
  }

  file { "/home/${user}/zookeeper":
    ensure  => 'link',
    target  => "/home/${user}/zookeeper-${version}",
    owner   => $user,
    require => Exec["extract zookeeper-${version}"]
  }

}