# Install sqoop jdbc jar files
class sqoop::jdbcs($user, $shareFolder) {

  $postgreSqlJar = 'postgresql-9.3-1102.jdbc41.jar'
  $postgreSqlUrl = 'http://jdbc.postgresql.org/download/'

  exec { 'Download PostgreSQL JDBC':
    command   => "wget ${postgreSqlUrl}${postgreSqlJar}",
    path      => '/bin:/usr/bin:/sbin',
    user      => 'root',
    cwd       => $shareFolder,
    onlyif    => "test ! -f ${$shareFolder}/${postgreSqlJar}",
    timeout   => 1800 # 30 minutes `should be more than enough`
  }

  exec { 'Copy jdbc jar files':
    command => "cp *jdbc*.jar /home/${user}/sqoop/lib",
    cwd     => $shareFolder,
    path    => '/bin:/usr/bin:/sbin',
    require => Exec['Download PostgreSQL JDBC']
  }

}