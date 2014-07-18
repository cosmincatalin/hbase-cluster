# Install Hadoop by downloading it, extracting it and linking it
class hadoop::install($user, $version, $shareFolder) {

  $protocol = 'http'
  $domain = 'mirrors.dotsrc.org'
  $path = "/apache/hadoop/common/hadoop-${version}/"
  $file = "hadoop-${version}.tar.gz"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { "download hadoop-${version}":
    command   => "wget ${protocol}://${domain}${path}${file}",
    cwd       => $shareFolder,
    user      => 'root',
    timeout   => 1800, # 30 minutes `should be more than enough`,
    onlyif    => "test ! -f ${$shareFolder}/${file}"
  }

  exec { "extract hadoop-${version}":
    command => "tar -xvf ${file} -C /home/${user}",
    cwd     => $shareFolder,
    require => Exec["download hadoop-${version}"]
  }

  file { "/home/${user}/hadoop":
    ensure  => 'link',
    target  => "/home/${user}/hadoop-${version}",
    owner   => $user,
    require => Exec["extract hadoop-${version}"]
  }

  exec { "add HADOOP_COMMON_HOME to ${user} profile":
    command => "echo 'export HADOOP_COMMON_HOME=/home/${user}/hadoop' >> /home/${user}/.bashrc",
    require => File["/home/${user}/hadoop"]
  }

  exec { "add HADOOP_MAPRED_HOME to ${user} profile":
    command => "echo 'export HADOOP_MAPRED_HOME=/home/${user}/hadoop' >> /home/${user}/.bashrc",
    require => File["/home/${user}/hadoop"]
  }

}