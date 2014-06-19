# Starts Hadoop related services
class hadoop::start($user, $isMaster) {

  $hadoopHome = "/home/${user}/hadoop"
  $hadoopSbin = "${hadoopHome}/sbin"
  $hadoopBin = "${hadoopHome}/bin"
  $hadoopConf = "${hadoopHome}/etc/hadoop"
  $hadoopDaemon = "${hadoopSbin}/hadoop-daemon.sh --config ${hadoopConf}"

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
  }

  if !$isMaster {
    exec { 'start datanode':
      command => "${hadoopDaemon} --script hdfs start datanode",
      require => Exec['format hdfs']
    }
  }

}