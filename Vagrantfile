VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of Hadoop Data Nodes to raise
  numberOfDataNodes = 3
  # The user under which all Hadoop services will run under
  user = 'hduser'
  # The Hadoop version
  hadoopVersion = '2.4.0'
  # The cluster will be raised on a private network form the non-addressable set
  baseIp = '192.168.66.6'
  # The postfix for the machines on the cluster
  baseName = '.cluster.lab'
  # The path where files are shared between machines
  sharePath = '/mnt/vshare'
  # The file name of the shared master key
  masterKey = 'master_key.pub'

  # Trusty Tahr Ubuntu
  config.vm.box = 'ubuntu/trusty64'

  # The puppet folder needs to be shared explicitly for the provisioning to work
  config.vm.synced_folder 'puppet', '/puppet'
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder 'share', sharePath, create: true

  # Rise the Master which is the default machine
  config.vm.define :master, primary: true do |master|
    # The master is placed at 192.168.66.60
    master.vm.network 'private_network', ip: '192.168.66.60'

    # The master is called master.cluster.lab
    master.vm.hostname = 'master' + baseName

    # start the actual provisioning of the master
    master.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      puppet.manifest_file  = 'master.pp'
      puppet.module_path    = 'puppet/modules'
      puppet.options        = '--verbose'
      puppet.facter         = {
        'user'            => user,
        'hadoop_version'  => hadoopVersion,
        'share_path'      => sharePath,
        'shared_key'      => masterKey,
        'nodes_number'    => numberOfDataNodes,
        'base_ip'         => baseIp
      }
    end
  end

  # Rise the Data Nodes
  1.upto(numberOfDataNodes) do |index|
    # The salves are identified as slave-*
    nodeName = 'slave-' + index.to_s

    config.vm.define nodeName do |node|
      # The slaves are placed at 192.168.66.6*
      node.vm.network :private_network, ip: baseIp + index.to_s

      # The slaves are called slave-*.cluster.lab
      node.vm.hostname = 'slave-' + index.to_s + baseName

      # start the actual provisioning of the master
      node.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'slave.pp'
        puppet.module_path    = 'puppet/modules'
        puppet.options        = '--verbose'
        puppet.facter         = {
          'user'            => user,
          'hadoop_version'  => hadoopVersion,
          'share_path'      => sharePath,
          'shared_key'      => masterKey,
          'base_ip'         => baseIp
        }
      end
    end
  end

end