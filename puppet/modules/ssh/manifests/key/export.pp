# Move the public key to a folders that is supposed to be shared between
# the cluster's node. This way, the slaves can import the master's
# public key
define ssh::key::export($user, $shareFolder, $key) {

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => 'root'
  }

  exec { 'Clean destination':
    command => "rm -f ${shareFolder}/${key}"
  }

  exec { 'Copy public key to shared location':
    command => "cp /home/${user}/.ssh/id_dsa.pub ${shareFolder}/${key}",
    require => Exec['Clean destination']
  }
}