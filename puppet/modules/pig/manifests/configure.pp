# Configures pig
class pig::configure($user) {

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  exec { "add PIG_HOME to ${user} profile":
    command => "echo 'export PIG_HOME=/home/${user}/pig' >> /home/${user}/.bashrc"
  }

  exec { "add PIG_HOME/bin to ${user} profile":
    command => "echo 'export PATH=\$PATH:\$PIG_HOME/bin' >> /home/${user}/.bashrc"
  }
}