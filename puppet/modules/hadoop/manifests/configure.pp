class hadoop::configure($user) {

  $javaHome = '$(readlink -f \/usr\/bin\/javac | sed "s:\/bin\/javac::")'

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { 'Add JAVA_HOME to hadoop-env.sh':
    command => "sed -i 's/\${JAVA_HOME}/${javaHome}/' hadoop-env.sh",
    cwd     => "/home/${user}/hadoop/etc/hadoop"
  }

  hadoop::addslaves{ 'add slaves to hadoop configuration':
    count => 3,
    user => $user
  }

  augeas { 'core-site':
    incl  => "/home/${user}/hadoop/etc/hadoop/core-site.xml",
    lens  => 'Xml.lns',
    changes => [
      "set configuration/property[last()+1]/name/#text 'fs.defaultFS'",
      "set configuration/property[last()]/value/#text 'hdfs://master:54310'",
      "set configuration/property[last()+1]/name/#text 'mapreduce.jobtracker.address'",
      "set configuration/property[last()]/value/#text 'master:54311'",
      "set configuration/property[last()+1]/name/#text 'hadoop.tmp.dir'",
      "set configuration/property[last()]/value/#text '/home/${user}/hadoop/tmp'"
    ]
  }

  augeas { 'hdfs-site':
    incl  => "/home/${user}/hadoop/etc/hadoop/hdfs-site.xml",
    lens  => 'Xml.lns',
    changes => [
      "set configuration/property[last()+1]/name/#text 'dfs.replication'",
      "set configuration/property[last()]/value/#text '2'",
      "set configuration/property[last()+1]/name/#text 'dfs.datanode.data.dir'",
      "set configuration/property[last()]/value/#text '/home/${user}/hadoop/data'"
    ]
  }
}