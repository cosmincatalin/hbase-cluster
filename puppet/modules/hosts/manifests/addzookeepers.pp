# A recursive type for adding a variable amount of zookeepers hostnames to
# the hosts file
define hosts::addzookeepers($count, $base) {
  host { "zookeeper-${count}":
    ip => "${base}${count}"
  }

  $next = inline_template('<%= @count.to_i - 1 %>')
  if $next != '0' {
    hosts::addzookeepers { "add zookeeper-${next}":
      count => $next,
      base  => $base
    }
  }
}