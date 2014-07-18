# Installs Sqoop
class sqoop ($user, $shareFolder, $version) {

    class { 'sqoop::install':
      user        => $user,
      version     => $version,
      shareFolder => $shareFolder
    }

}