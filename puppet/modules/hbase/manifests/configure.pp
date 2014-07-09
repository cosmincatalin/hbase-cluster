# Configures a HBase node. All nodes are born equal from the point
# of view of the configuration.
class hbase::configure($user, $zookeeperEnsembleSize, $hadoopClusterSize) {

  $hbaseConfDir  = "/home/${user}/hbase/conf"
  $propPath   = 'set configuration/property'
  $javaHome = '$(readlink -f \/usr\/bin\/javac | sed "s:\/bin\/javac::")'
  $hbaseTempFolder = "/home/${user}/hbase/tmp"
  $hbaseLocalFolder = "/home/${user}/hbase/local"

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin',
    cwd   => $hbaseConfDir
  }

  # Ensure a specific folder structure
  file { [
    "/home/${user}/hbase/local",
    "/home/${user}/hbase/tmp"] :
    ensure  => 'directory',
    owner   => $user
  }

  exec { 'Add JAVA_HOME to hbase-env.sh':
    command => "sed -i 's/# export JAVA_HOME=\\/usr\\/java\\/jdk1.6.0\\//export JAVA_HOME=${javaHome}/' hbase-env.sh"
  }

  exec { 'Set HBASE_MANAGES_ZK in hbase-env.sh':
    command => "sed -i 's/# export HBASE_MANAGES_ZK=true/export HBASE_MANAGES_ZK=false/' hbase-env.sh"
  }

  exec { 'Set HBASE_CLASSPATH in hbase-env.sh':
    command => "sed -i 's/# export HBASE_CLASSPATH=/export HBASE_CLASSPATH=\\/home\\/${user}\\/hadoop\\/etc\\/hadoop/' hbase-env.sh"
  }

  exec { 'truncate regionservers file':
    command => "truncate -s0 regionservers",
    user    => 'root'
  }

  hbase::addregionservers{ 'add servers to regionservers file':
    count   => $hadoopClusterSize,
    user    => $user,
    require => Exec['truncate regionservers file']
  }

  file { "${hbaseConfDir}/hbase-site.xml":
    path    => "${hbaseConfDir}/hbase-site.xml",
    owner   => $user,
    group   => 'hadoop',
    mode    => '0755',
    content => template('hbase/hbase-site.xml.erb')
  }
}