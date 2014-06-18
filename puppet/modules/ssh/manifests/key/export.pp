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