# A recursive type for adding avariable amount of slave hostnames to
# the hosts file
define hosts::addslaves($count, $base) {
  host { "slave-${count}":
    ip => "${base}${count}"
  }
  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    addslaves { "add slave-${next}":
      count => $next,
      base  => $base
    }
  }
}