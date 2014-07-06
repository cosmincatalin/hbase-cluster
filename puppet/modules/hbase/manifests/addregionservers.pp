# Adds the regionservers' hostnames to HBase's slaves file.
define hbase::addregionservers($user, $count) {

  $hbaseConfDir  = "/home/${user}/hbase/conf"

  exec { "Add regionserver-${count} to conf":
    command => "echo \"slave-${count}\" >> regionservers",
    user    => $user,
    cwd     => $hbaseConfDir,
    path    => '/bin:/usr/bin:/sbin'
  }

  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    hbase::addregionservers { "add regionserver-${next}":
      count => $next,
      user  => $user
    }
  }
}