class swap($sizeInMb) {

  Exec {
    path  => '/bin:/usr/bin:/sbin',
    user  => 'root'
  }

  exec { 'create swapfile':
    command => "dd if=/dev/zero of=/swapfile bs=1024 count=${sizeInMb}k"
  }

  exec { 'prepare swapfile':
    command => 'mkswap /swapfile',
    require => Exec["create swapfile"]
  }

  exec { 'activate swapfile':
    command => 'swapon /swapfile',
    require => Exec["prepare swapfile"]
  }

}