# Install sqoop jdbcs
class sqoop::jdbcs($user) {

  $jdbcs = [
    'http://jdbc.postgresql.org/download/postgresql-9.3-1102.jdbc41.jar'
  ]

  exec { $jdbcs:
    command   => "wget ${jdbcs}",
    path      => '/bin:/usr/bin:/sbin',
    user      => $user,
    cwd       => "/home/${user}/sqoop/lib",
    timeout   => 1800 # 30 minutes `should be more than enough`
  }

}