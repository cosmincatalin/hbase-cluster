# A wrapper for creating a user along with a specified group
define identity::user::add ($user, $group ) {

  if !($user in $::users) {

    identity::group::add{ "Add group ${group}":
      group => $group
    }

    user { $user:
      ensure      => present,
      managehome  => true,
      groups      => [$group, 'sudo'],
      require     => Identity::Group::Add["Add group ${group}"]
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
      path    => '/bin:/usr/bin',
      require => File["/home/${user}"]
    }

  }
}