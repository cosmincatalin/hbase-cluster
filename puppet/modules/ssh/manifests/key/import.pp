# Take a public key from the common share folder and import it
# into the hosts's authorized hosts. This way the node to which the key
# belongs to can connect to the current node.
define ssh::key::import($user, $shareDir, $key) {

  file { "/home/${user}/.ssh/authorized_keys":
    mode    => '0755',
    owner   => $user
  }

  exec { 'Add key to authorized hosts':
    command => "cat ${shareDir}/${key} >> /home/${user}/.ssh/authorized_keys",
    path    => '/bin:/usr/bin:/sbin',
    user    => $user,
    require => File["/home/${user}/.ssh/authorized_keys"]
  }
}