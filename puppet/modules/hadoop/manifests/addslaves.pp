# Adds the slaves hostnames to Haddop's slaves file.
define hadoop::addslaves($user, $count) {

  $hadoopConfDir = "/home/${user}/hadoop/etc/hadoop"

  exec { "Add slave-${count} to conf":
    command => "echo \"slave-${count}\" >> ${hadoopConfDir}/slaves",
    user    => $user,
    path    => '/bin:/usr/bin:/sbin'
  }

  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    hadoop::addslaves { "add slave-${next} to slaves file":
      count => $next,
      user  => $user
    }
  }
}