class hadoop ($user, $version) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "/apache/hadoop/common/hadoop-${version}/"
  $file = "hadoop-${version}.tar.gz"
  $autoJavaHome = '$(readlink -f \/usr\/bin\/javac | sed "s:\/bin\/javac::")'

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

  exec { 'Add JAVA_HOME to hadoop-env.sh':
    command => "sed -i 's/\${JAVA_HOME}/${autoJavaHome}/' hadoop-env.sh",
    cwd     => "/home/${user}/hadoop/etc/hadoop",
    require => File["/home/${user}/hadoop"]
  }

  exec { 'format hdfs':
    command => "/home/${user}/hadoop/bin/hdfs namenode -format",
    require => Exec['Add JAVA_HOME to hadoop-env.sh']
  }

}