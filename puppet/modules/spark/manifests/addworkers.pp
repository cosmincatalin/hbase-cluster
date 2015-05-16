# Adds the workers hostnames to Haddop's slaves file.
define spark::addworkers($user, $count) {

  $sparkConfDir = "/home/${user}/spark/conf"

  exec { "Add worker-${count} to conf":
    command => "echo \"slave-${count}\" >> ${sparkConfDir}/slaves",
    user    => $user,
    path    => '/bin:/usr/bin:/sbin'
  }

  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    spark::addworkers { "add slave-${next} to slaves file":
      count => $next,
      user  => $user
    }
  }
} 