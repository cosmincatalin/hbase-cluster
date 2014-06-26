VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of Hadoop Data Nodes to raise
  numberOfDataNodes = 3
  # The number of nodes in the Zookeeper cluster
  zookeeperClusterSize = 3
  # The user under which all Hadoop services will run under
  user = 'hduser'
  # The Hadoop version
  hadoopVersion = '2.4.0'
  # The Zookeeper version
  zookeeperVersion = '3.4.6'
  # The cluster will be raised on a private network form the non-addressable set
  baseIp = '192.168.66.'
  # The Hadoop base ip
  hadoopBaseIp = baseIp + '6'
  # The Zookeeper base ip
  zookeeperBaseIp = baseIp + '7'
  # The postfix for the machines on the cluster
  baseName = '.cluster.lab'
  # The path where files are shared between machines
  sharePath = '/mnt/vshare'
  # The file name of the shared master key
  masterKey = 'master_key.pub'

  # Trusty Tahr Ubuntu
  config.vm.box = 'ubuntu/trusty32'

  # The puppet folder needs to be shared explicitly for the provisioning to work
  config.vm.synced_folder 'puppet', '/puppet'
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder 'share', sharePath, create: true

  # Rise the Zookeeper
  1.upto(zookeeperClusterSize) do |index|
    # The nodes are identified as zookeeper-*
    nodeName = 'zookeeper-' + index.to_s

    config.vm.define nodeName do |node|
      # The nodes are placed at 192.168.66.7*
      node.vm.network :private_network, ip: zookeeperBaseIp + index.to_s

      # The nodes are called zookeeper-*.cluster.lab
      node.vm.hostname = 'zookeeper-' + index.to_s + baseName

      # start the actual provisioning
      node.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'zookeeper.pp'
        puppet.module_path    = 'puppet/modules'
        puppet.options        = '--verbose'
        puppet.facter         = {
          'user'                => user,
          'zookeeper_version'   => zookeeperVersion,
          'cluster_size'        => zookeeperClusterSize,
          'server_id'           => index,
          'base_ip'             => zookeeperBaseIp
        }
      end
    end
  end

  # Rise the Master which is the default machine
  config.vm.define :master, primary: true do |master|
    # The master is placed at 192.168.66.60
    master.vm.network 'private_network', ip: hadoopBaseIp + '0'
    # NameNode
    master.vm.network :forwarded_port, guest: 50070, host: 24200
    # Resource Manager
    master.vm.network :forwarded_port, guest: 8088, host: 24201
    # MapReduce JobHistory Server
    master.vm.network :forwarded_port, guest: 19888, host: 24202

    # The master is called master.cluster.lab
    master.vm.hostname = 'master' + baseName

    master.vm.provider "virtualbox" do |v|
      v.memory = 2048
    end

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
        'base_ip'         => hadoopBaseIp
      }
    end
  end

  # Rise the Data Nodes
  1.upto(numberOfDataNodes) do |index|
    # The slaves are identified as slave-*
    nodeName = 'slave-' + index.to_s

    config.vm.define nodeName do |node|
      # The slaves are placed at 192.168.66.6*
      node.vm.network :private_network, ip: hadoopBaseIp + index.to_s

      # The slaves are called slave-*.cluster.lab
      node.vm.hostname = 'slave-' + index.to_s + baseName

      # start the actual provisioning
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
          'base_ip'         => hadoopBaseIp
        }
      end
    end
  end

end