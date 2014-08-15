# Starts a Zookeeper server
class zookeeper::start($user) {

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

  exec { 'start zookeeper':
    command => "/home/${user}/zookeeper/bin/zkServer.sh start",
    cwd    => "/home/${user}/zookeeper/bin"
  }

  cron { 'start zookeeper on boot':
    user  => $user,
    special => 'reboot',
    command => "cd /home/${user}/zookeeper/bin && /home/${user}/zookeeper/bin/zkServer.sh start"
  }

}