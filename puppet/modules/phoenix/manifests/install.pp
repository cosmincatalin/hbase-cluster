# Install Hadoop by downloading it, extracting it and linking it
class phoenix::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'archive.apache.org'
  $path = "/dist/phoenix/phoenix-${version}/bin/"
  $file = "phoenix-${version}-bin.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download phoenix-${version}":
    command   => "wget ${protocol}://${domain}${path}${file}",
    cwd       => $shareFolder,
    logoutput => true,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`
    onlyif    => "test ! -f ${$shareFolder}/${file}"
  }

  exec { "extract phoenix-${version}":
    command => "tar -xvf ${file} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download phoenix-${version}"]
  }

  file { "/home/${user}/phoenix":
    ensure  => 'link',
    target  => "/home/${user}/phoenix-${version}-bin",
    owner   => $user,
    require => Exec["extract phoenix-${version}"]
  }

  file { "/home/${user}/hbase/lib/phoenix.jar":
    ensure  => 'link',
    force   => true,
    target  => "/home/${user}/phoenix/common/phoenix-core-${version}-bin.jar",
    owner   => $user,
    require => Exec["extract phoenix-${version}"]
  }

}