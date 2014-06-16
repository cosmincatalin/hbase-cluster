class java ($user) {

  $accept = 'echo debconf shared/accepted-oracle-license-v1-1 select true'
  $seen = 'echo debconf shared/accepted-oracle-license-v1-1 seen true'
  $setSelection = 'sudo debconf-set-selections'
  $javaHome = '$(readlink -f /usr/bin/javac | sed "s:/bin/javac::")'

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => 'root'
  }

  if $java_version !~ /1\.7.*/ {
    exec { 'add oracle java repo':
      command => 'add-apt-repository -y ppa:webupd8team/java'
    }

    exec { 'oracle java repo update':
      command => 'apt-get update',
      require => [Exec['add oracle java repo']]
    }

    exec { 'accept java oracle licence':
      command => "${accept} | ${setSelection} && ${seen} | ${setSelection}",
      require => Exec['oracle java repo update']
    }

    exec { "install java":
      command   => 'apt-get install -y oracle-java7-installer',
      require   => Exec['accept java oracle licence'],
      logoutput => true,
      timeout   => 1800 # 30 minutes `should be more than enough`
    }

    exec { "add JAVA_HOME to $user profile":
      command => "echo 'export JAVA_HOME=${javaHome}' >> /home/${user}/.bashrc",
      require => Exec['install java']
    }
  }

}