# Just a wrapper for consistency
define identity::group::add($group) {
    group { $group:
      ensure  => 'present'
    }
}