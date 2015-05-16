# Configures a Hadoop node. All nodes are born equal from the point
# of view of the configuration.
class hadoop::configure($user) {

  $hadoopConfDir  = "/home/${user}/hadoop/etc/hadoop"
  $propPath   = 'set configuration/property'

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  # Ensure a specific folder structure
  file { [
      "/home/${user}/hadoop/data",
      "/home/${user}/hadoop/tmp",
      "/home/${user}/hadoop/namenode" ]:
    ensure  => 'directory',
    owner   => $user
  }

  $javaHome = '$(readlink -f \/usr\/bin\/javac | sed "s:\/bin\/javac::")'

  exec { 'Add JAVA_HOME to hadoop-env.sh':
    command => "sed -i 's/\${JAVA_HOME}/${javaHome}/' hadoop-env.sh",
    cwd     => $hadoopConfDir
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
    incl    => "${hadoopConfDir}/core-site.xml",
    lens    => 'Xml.lns',
    changes => [
      "${propPath}[last()+1]/name/#text 'fs.defaultFS'",
      "${propPath}[last()]/value/#text 'hdfs://master'",
      "${propPath}[last()+1]/name/#text 'hadoop.tmp.dir'",
      "${propPath}[last()]/value/#text '/home/${user}/hadoop/tmp'"
    ]
  }

  augeas { 'hdfs-site':
    incl    => "${hadoopConfDir}/hdfs-site.xml",
    lens    => 'Xml.lns',
    changes => [
      "${propPath}[last()+1]/name/#text 'dfs.replication'",
      "${propPath}[last()]/value/#text '2'",
      "${propPath}[last()+1]/name/#text 'dfs.datanode.data.dir'",
      "${propPath}[last()]/value/#text 'file:///home/${user}/hadoop/data'",
      "${propPath}[last()+1]/name/#text 'dfs.namenode.name.dir'",
      "${propPath}[last()]/value/#text 'file:///home/${user}/hadoop/namenode'"
    ]
  }

  augeas { 'yarn-site':
    incl    => "${hadoopConfDir}/yarn-site.xml",
    lens    => 'Xml.lns',
    changes => [
      "${propPath}[last()+1]/name/#text 'yarn.resourcemanager.hostname'",
      "${propPath}[last()]/value/#text 'master'",
      "${propPath}[last()+1]/name/#text 'yarn.resourcemanager.webapp.address'",
      "${propPath}[last()]/value/#text '0.0.0.0:8088'",
      "${propPath}[last()+1]/name/#text 'yarn.resourcemanager.admin.address'",
      "${propPath}[last()]/value/#text '0.0.0.0:8033'",
      "${propPath}[last()+1]/name/#text 'yarn.nodemanager.aux-services'",
      "${propPath}[last()]/value/#text 'mapreduce_shuffle'"
    ]
  }

  file { "${hadoopConfDir}/mapred-site.xml":
    path    => "${hadoopConfDir}/mapred-site.xml",
    owner   => $user,
    group   => 'hadoop',
    mode    => '0644',
    content => template('hadoop/mapred-site.xml.erb')
  }

  exec { "add HADOOP_COMMON_HOME to ${user} profile":
    command => "echo 'export HADOOP_COMMON_HOME=/home/${user}/hadoop' >> /home/${user}/.bashrc"
  }

  exec { "add HADOOP_HOME to ${user} profile":
    command => "echo 'export HADOOP_HOME=/home/${user}/hadoop' >> /home/${user}/.bashrc"
  }

  exec { "add HADOOP_MAPRED_HOME to ${user} profile":
    command => "echo 'export HADOOP_MAPRED_HOME=/home/${user}/hadoop' >> /home/${user}/.bashrc"
  }

  exec { "add HADOOP_HOME/bin to ${user} profile":
    command => "echo 'export PATH=\$PATH:\$HADOOP_HOME/bin' >> /home/${user}/.bashrc",
    require => Exec["add HADOOP_HOME to ${user} profile"]
  }

  exec { "add HADOOP_HOME/conf to ${user} profile":
    command => "echo 'export HADOOP_CONF_DIR=\$HADOOP_HOME/conf' >> /home/${user}/.bashrc",
    require => Exec["add HADOOP_HOME to ${user} profile"]
  }



}