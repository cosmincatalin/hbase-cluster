# Starts Hadoop related services
class hadoop::start($user, $isMaster) {

  $hadoopHome = "/home/${user}/hadoop"
  $hadoopSbin = "${hadoopHome}/sbin"
  $hadoopBin = "${hadoopHome}/bin"
  $hadoopConf = "${hadoopHome}/etc/hadoop"
  $hadoopDaemon = "${hadoopSbin}/hadoop-daemon.sh --config ${hadoopConf}"
  $yarnDaemon = "${hadoopSbin}/yarn-daemon.sh --config ${hadoopConf}"
  $jhDaemon = "${hadoopSbin}/mr-jobhistory-daemon.sh --config ${hadoopConf}"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  if $isMaster {
    exec { 'format hdfs':
      command => "${hadoopBin}/hdfs namenode -format local.lab"
    }

    exec { 'start namnode':
      command => "${hadoopDaemon} --script hdfs start namenode",
      require => Exec['format hdfs']
    }

    # Can be moved to its own virtual machine
    exec { 'start resourcemanager':
      command => "${yarnDaemon} start resourcemanager",
      require => Exec['start namnode']
    }

    # @todo: Look into inserting the WebAppProxy server here

    # Can be moved to its own virtual machine
    exec { 'start jobhistory':
      command => "${jhDaemon} start historyserver",
      require => Exec['start resourcemanager']
    }
  }

  if !$isMaster {
    exec { 'start datanode':
      command => "${hadoopDaemon} --script hdfs start datanode"
    }

    exec { 'start nodemanager':
      command => "${yarnDaemon} start nodemanager",
      require => Exec['start datanode']
    }
  }

}