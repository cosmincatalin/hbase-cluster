require 'facter'

Facter.add("reource_manager_running") do
    setcode do
        `sudo /usr/bin/jps 2>&1`.match('ResourceManager')[0] == 'ResourceManager'
    end
end