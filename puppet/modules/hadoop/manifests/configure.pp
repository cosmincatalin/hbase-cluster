# Configures a Hadoop node. All nodes are born equal from the point
# of view of the configuration.
class hadoop::configure($user) {

  $hadoopConfDir  = "/home/${user}/hadoop/etc/hadoop"
  $propertyPath   = 'configuration/property'

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  $javaHome = '$(readlink -f \/usr\/bin\/javac | sed "s:\/bin\/javac::")'

  exec { 'Add JAVA_HOME to hadoop-env.sh':
    command => "sed -i 's/\${JAVA_HOME}/${javaHome}/' hadoop-env.sh",
    cwd     => "/home/${user}/hadoop/etc/hadoop"
  }

  exec { 'truncate slaves first':
    command => "truncate -s0 ${hadoopConfDir}/slaves",
    user    => 'root'
  }

  hadoop::addslaves{ 'add slaves to hadoop configuration':
    count => 3,
    user  => $user
  }

  augeas { 'core-site':
    incl    => "/home/${user}/hadoop/etc/hadoop/core-site.xml",
    lens    => 'Xml.lns',
    changes => [
      "set ${propertyPath}[last()+1]/name/#text 'fs.defaultFS'",
      "set ${propertyPath}[last()]/value/#text 'hdfs://master:8020'",
      "set ${propertyPath}[last()+1]/name/#text 'hadoop.tmp.dir'",
      "set ${propertyPath}[last()]/value/#text '/home/${user}/hadoop/tmp'"
    ]
  }

  augeas { 'hdfs-site':
    incl    => "/home/${user}/hadoop/etc/hadoop/hdfs-site.xml",
    lens    => 'Xml.lns',
    changes => [
      "set ${propertyPath}[last()+1]/name/#text 'dfs.replication'",
      "set ${propertyPath}[last()]/value/#text '2'",
      "set ${propertyPath}[last()+1]/name/#text 'dfs.datanode.data.dir'",
      "set ${propertyPath}[last()]/value/#text '/home/${user}/hadoop/data'",
      "set ${propertyPath}[last()+1]/name/#text 'dfs.namenode.name.dir'",
      "set ${propertyPath}[last()]/value/#text '/home/${user}/hadoop/namenode'"
    ]
  }
}