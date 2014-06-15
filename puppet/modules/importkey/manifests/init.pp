class importkey ($user, $shareFolder, $key) {
  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  file { "/home/${user}/.ssh":
    ensure  => 'directory',
    mode    => '755',
    owner   => $user
  }

  file { "/home/${user}/.ssh/authorized_keys":
    mode    => '755',
    owner   => $user,
    require => File["/home/${user}/.ssh"]
  }

  exec { 'Add master key to authorized hosts':
    command => "cat ${shareFolder}/${key} >> /home/${user}/.ssh/authorized_keys",
    require => File["/home/${user}/.ssh/authorized_keys"]
  }
}