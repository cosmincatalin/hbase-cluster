require 'thread'
require 'facter'
require 'puppet'

if Facter.value(:kernel) == 'Linux'
  mutex = Mutex.new

  users = []

  Puppet::Type.type('user').instances.each do |user|
    instance = user.retrieve

    mutex.synchronize do
      users << user.name unless instance[user.property(:uid)].to_i < 500
    end
  end

  Facter.add('users') do
    confine :kernel => :linux
    setcode { users.sort.join(',') }
  end
end