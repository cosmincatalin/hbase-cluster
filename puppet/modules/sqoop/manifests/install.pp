# Install sqoop by downloading it, extracting it and linking it
class sqoop::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/sqoop/${version}/"
  $file = "sqoop-${version}-bin-hadoop200"
  $archive = "${file}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download sqoop-${version}":
    command   => "wget ${protocol}://${domain}${path}${archive}",
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