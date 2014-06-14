class usergroup($user, $group) {

  Exec {
    path  => '/bin:/usr/bin'
  }

  if !($user in $users) {

    group { "${group}":
      ensure  => 'present'
    }

    user { $user:
      ensure      => present,
      managehome  => true,
      groups      => [$group, 'sudo'],
      require     => Group[$group]
    }

    file { "/home/${user}":
      recurse => true,
      owner   => $user,
      group   => $group,
      require => User[$user]
    }

    exec { 'config_shell':
      command => "chsh -s /bin/bash ${user}",
      user    => 'root',
      require => File["/home/${user}"]
    }
  }

}