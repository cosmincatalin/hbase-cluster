define hadoop::addslaves($user, $count) {

  $hadoopConfDir = "/home/${user}/hadoop/etc/hadoop"

  util::exec { "Add slave-${count} to conf":
    command => "echo \"slave-${count}\n\" >> ${hadoopConfDir}/slaves",
    user    => $user
  }

  $next = inline_template('<%= @count.to_i - 1 %>')
  if "${next}" == '0' {
  } else {
    hadoop::addslaves { "add slave-${next}":
      count => $next,
      user => $user
    }
  }
}