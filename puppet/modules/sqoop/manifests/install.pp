# Install sqoop by downloading it, extracting it and linking it
class sqoop::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "/apache/sqoop/${version}/"
  $file = "sqoop-${version}.bin__hadoop-2.0.4-alpha"
  $archive = "${file}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download sqoop-${version}":
    command   => "wget ${protocol}://${domain}${path}${file}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`
    onlyif    => "test ! -f ${$shareFolder}/${archive}"
  }

  exec { "extract sqoop-${version}":
    command => "tar -xvf ${archive} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download sqoop-${version}"]
  }

  file { "/home/${user}/sqoop":
    ensure  => 'link',
    target  => "/home/${user}/${file}",
    owner   => $user,
    require => Exec["extract sqoop-${version}"]
  }

}