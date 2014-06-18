define ssh::key::generate($user) {

  exec { 'Generate common public key':
    command => "ssh-keygen -t rsa -P '' -f /home/${user}/.ssh/id_dsa",
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  file { "/home/${user}/.ssh/config":
    mode    => '755',
    owner   => $user,
    group   => $group,
    require => Exec['Generate common public key']
  }
}