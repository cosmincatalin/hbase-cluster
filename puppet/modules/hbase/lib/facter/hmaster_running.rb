require 'facter'

Facter.add("hmaster_running") do
    setcode do
        `sudo /usr/bin/jps 2>&1`.match('HMaster')[0] == 'HMaster'
    end
end