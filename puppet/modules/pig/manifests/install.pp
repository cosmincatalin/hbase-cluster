# Install Hive by downloading it, extracting it and linking it
class pig::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "apache/pig/pig-${version}/"
  $file = "pig-${version}"
  $archive = "pig-${version}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download pig-${version}":
    command   => "wget ${protocol}://${domain}${path}${archive}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`,
    onlyif    => "test ! -f ${$shareFolder}/${archive}"
  }

  exec { "extract pig-${version}":
    command => "tar -xvf ${archive} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download pig-${version}"]
  }

  file { "/home/${user}/pig":
    ensure  => 'link',
    target  => "/home/${user}/${file}",
    owner   => $user,
    require => Exec["extract pig-${version}"]
  }

}