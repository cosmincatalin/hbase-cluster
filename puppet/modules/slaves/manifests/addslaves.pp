define addslaves($count, $base) {
  host { "slave-${count}":
    ip => "${base}${count}"
  }
  $next = inline_template('<%= @count.to_i - 1 %>')
  if "${next}" == '0' {
    host { 'add localhost':
      name  => 'localhost',
      ip    => '127.0.0.1'
    }
  } else {
    addslaves { "add slave-${next}":
      count => $next,
      base  => $base
    }
  }
}