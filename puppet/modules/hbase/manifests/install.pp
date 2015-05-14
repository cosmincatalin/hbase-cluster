# Install HBase by downloading it, extracting it and linking it
class hbase::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/hbase/hbase-${version}/"
  $file = "hbase-${version}-hadoop2"
  $archive = "${file}-bin.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download hbase-${version}":
    command   => "wget ${protocol}://${domain}${path}${archive}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`,
    onlyif    => "test ! -f ${$shareFolder}/${archive}"
  }

  exec { "extract hbase-${version}":
    command => "tar -xvf ${archive} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download hbase-${version}"]
  }

  file { "/home/${user}/hbase":
    ensure  => 'link',
    target  => "/home/${user}/${file}",
    owner   => $user,
    require => Exec["extract hbase-${version}"]
  }

}