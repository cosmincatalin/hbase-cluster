# A recursive type for adding a variable amount of zookeeper hostnames to
# the hosts file
define hosts::addzookeepers($count, $base) {
  host { "zookeeper-${count}":
    ip => "${base}${count}"
  }
  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    addzookeepers { "add zookeeper-${next}":
      count => $next,
      base  => $base
    }
  }
}