class sharekey ($user, $group, $shareFolder, $key) {

  $identity = "\tIdentityFile /home/${user}/.ssh/id_dsa"
  $ignore   = "\tStrictHostKeyChecking no"

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => $user
  }

  exec { 'Generate common public key':
    command => "ssh-keygen -t rsa -P '' -f /home/${user}/.ssh/id_dsa"
  }

  exec { 'Clean destination':
    command => "rm -f ${shareFolder}/${key}",
    user    => 'root',
    require => Exec['Generate common public key']
  }

  exec { 'Copy public key to shared location':
    command => "cp /home/${user}/.ssh/id_dsa.pub ${shareFolder}/${key}",
    user    => 'root',
    require => Exec['Clean destination']
  }

  file { "/home/${user}/.ssh/config":
    mode    => '755',
    owner   => $user,
    group   => $group,
    content => "Host slave-*\n${identity}\n${ignore}",
    require => Exec['Generate common public key']
  }
}