require 'facter'

Facter.add("quroum_running") do
    setcode do
        `sudo /usr/bin/jps 2>&1`.match('QuorumPeerMain')[0] == 'QuorumPeerMain'
    end
end