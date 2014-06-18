define ssh::key::import($user, $shareFolder, $key) {

  file { "/home/${user}/.ssh/authorized_keys":
    mode    => '755',
    owner   => $user
  }

  exec { 'Add key to authorized hosts':
    command => "cat ${shareFolder}/${key} >> /home/${user}/.ssh/authorized_keys",
    path  => '/bin:/usr/bin:/sbin',
    user  => $user,
    require => File["/home/${user}/.ssh/authorized_keys"]
  }
}