class hadoop::start($user) {

  $hadoopHome = "/home/${user}/hadoop"
  $hadoopSbin = "${hadoopHome}/sbin"
  $hadoopBin = "${hadoopHome}/bin"
  $hadoopConf = "${hadoopHome}/etc/hadoop"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { 'format hdfs':
    command => "${hadoopBin}/hdfs namenode -format local.lab"
  }

  # exec { 'start hdfs':
  #   command => "${hadoopSbin}/hadoop-daemon.sh --config ${hadoopConf} --script hdfs start namenode"
  # }

}