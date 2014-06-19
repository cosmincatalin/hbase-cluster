# Add an alias to the ssh config for a host. It is allowed
# to specify wildcards. For Hadoop operations, it's sufficient to
# ignore the fingerprint warning when connecting
define ssh::config($user, $host) {

  $identity = "\tIdentityFile /home/${user}/.ssh/id_dsa"
  $ignore   = "\tStrictHostKeyChecking no"
  $entry    = "Host ${host}\n${identity}\n${ignore}\n"

  exec { "Add ssh config for host ${host}":
    command => "echo \"${entry}\" >> /home/${user}/.ssh/config",
    path    => '/bin:/usr/bin:/sbin',
    user    => $user
  }
}