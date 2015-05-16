# Configures a Spark node. All nodes are born equal from the point
# of view of the configuration.
class spark::configure($user, $clusterSize) {

  $sparkConfDir  = "/home/${user}/spark/conf"

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  exec { 'truncate workers first':
    command => "truncate -s0 ${sparkConfDir}/slaves"
  }

  spark::addworkers{ 'add workers to spark configuration':
    count => $clusterSize,
    user  => $user
  }

  file { "${sparkConfDir}/spark-defaults.conf":
    path    => "${sparkConfDir}/spark-defaults.conf",
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('spark/spark-defaults.conf.erb')
  }

  exec { "add SPARK_HOME to ${user} profile":
    command => "echo 'export SPARK_HOME=/home/${user}/spark' >> /home/${user}/.bashrc"
  }

  exec { "add SPARK_HOME/bin to ${user} profile":
    command => "echo 'export PATH=\$PATH:\$SPARK_HOME/bin' >> /home/${user}/.bashrc",
    require => Exec["add SPARK_HOME to ${user} profile"]
  }
}