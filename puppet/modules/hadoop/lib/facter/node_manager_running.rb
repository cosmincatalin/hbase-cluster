require 'facter'

Facter.add("node_manager_running") do
    setcode do
        `sudo /usr/bin/jps 2>&1`.match('NodeManager')[0] == 'NodeManager'
    end
end