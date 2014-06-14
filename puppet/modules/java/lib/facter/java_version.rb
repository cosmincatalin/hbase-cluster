require 'facter'

Facter.add("java_version") do
    setcode do
        `/usr/bin/java -version 2>&1`.split("\n")[0].split('"')[1]
    end
end