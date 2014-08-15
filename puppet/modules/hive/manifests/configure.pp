# Configures a hive node. All nodes are born equal from the point
# of view of the configuration.
class hive::configure($user) {

  Exec {
    user  => $user,
    path  => '/bin:/usr/bin:/sbin'
  }

  exec { "add HIVE_HOME to ${user} profile":
    command => "echo 'export HIVE_HOME=/home/${user}/hive' >> /home/${user}/.bashrc"
  }

  exec { "add HIVE_HOME/bin to ${user} profile":
    command => "echo 'export PATH=\$PATH:\$HIVE_HOME/bin' >> /home/${user}/.bashrc",
    require => Exec["add HIVE_HOME to ${user} profile"]
  }
}