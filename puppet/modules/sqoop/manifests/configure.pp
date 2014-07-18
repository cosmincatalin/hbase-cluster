# Install Hadoop by downloading it, extracting it and linking it
class sqoop::configure($user) {

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  exec { "add SQOOP_HOME to ${user} profile":
    command => "echo 'export SQOOP_HOME=/home/${user}/sqoop' >> /home/${user}/.bashrc"
  }

  exec { "add SQOOP_HOME/bin to ${user} profile":
    command => "echo 'export PATH=\$PATH:\$SQOOP_HOME/bin' >> /home/${user}/.bashrc"
  }

}