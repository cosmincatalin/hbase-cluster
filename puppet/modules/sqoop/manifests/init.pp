# Installs Sqoop
class sqoop ($user, $shareFolder, $version) {

    class { 'sqoop::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

    class { 'sqoop::jdbcs':
      user        => $user,
      shareFolder => $shareFolder,
      require     => Class['sqoop::install']
    }

    class { 'sqoop::configure':
      user    => $user,
      require => Class['sqoop::install']
    }

}