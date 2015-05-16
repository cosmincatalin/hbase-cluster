# Install Spark by downloading it, extracting it and linking it
class spark::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/spark/spark-${version}/"
  $file = "spark-${version}-bin-hadoop2.6"
  $archive = "${file}.tgz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download spark-${version}":
    command   => "wget ${protocol}://${domain}${path}${archive}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`,
    onlyif    => "test ! -f ${$shareFolder}/${archive}"
  }

  exec { "extract spark-${version}":
    command => "tar -xvf ${archive} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download spark-${version}"]
  }

  file { "/home/${user}/spark":
    ensure  => 'link',
    target  => "/home/${user}/${file}",
    owner   => $user,
    require => Exec["extract spark-${version}"]
  }

}