# Install Hadoop by downloading it, extracting it and linking it
class zookeeper::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/zookeeper/zookeeper-${version}/"
  $file = "zookeeper-${version}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download zookeeper-${version}":
    command   => "wget ${protocol}://${domain}${path}${file}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`
    onlyif    => "test ! -f ${$shareFolder}/${file}"
  }

  exec { "extract zookeeper-${version}":
    command => "tar -xvf ${file} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download zookeeper-${version}"]
  }

  file { "/home/${user}/zookeeper":
    ensure  => 'link',
    target  => "/home/${user}/zookeeper-${version}",
    owner   => $user,
    require => Exec["extract zookeeper-${version}"]
  }

}