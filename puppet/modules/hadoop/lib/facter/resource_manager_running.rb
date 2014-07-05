require 'facter'

Facter.add("resource_manager_running") do
    setcode do
        `sudo /usr/bin/jps 2>&1`.match('ResourceManager')[0] == 'ResourceManager'
    end
end