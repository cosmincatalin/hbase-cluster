# Install Hive by downloading it, extracting it and linking it
class hive::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/hive/hive-${version}/"
  $file = "apache-hive-${version}-bin"
  $archive = "${file}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download hive-${version}":
    command   => "wget ${protocol}://${domain}${path}${archive}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`,
    onlyif    => "test ! -f ${$shareFolder}/${archive}"
  }

  exec { "extract hive-${version}":
    command => "tar -xvf ${archive} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download hive-${version}"]
  }

  file { "/home/${user}/hive":
    ensure  => 'link',
    target  => "/home/${user}/${file}",
    owner   => $user,
    require => Exec["extract hive-${version}"]
  }

}