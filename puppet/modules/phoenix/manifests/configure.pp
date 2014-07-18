# Install Hadoop by downloading it, extracting it and linking it
class phoenix::configure($user) {

  file { "/home/${user}/phoenix/bin/hbase-site.xml":
    path    => "/home/${user}/phoenix/bin/hbase-site.xml",
    owner   => $user,
    group   => 'hadoop',
    mode    => '0755',
    content => template('phoenix/hbase-site.xml.erb')
  }

}