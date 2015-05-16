VAGRANTFILE_API_VERSION = '2'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # The number of Hadoop Data Nodes to raise
  hadoopClusterSize = 3
  # The number of nodes in the Zookeeper cluster
  zookeeperEnsembleSize = 3
  # The user under which all Hadoop services will run under
  user = 'hduser'
  # The Spark version
  sparkVersion = '1.3.1'
  # The Hadoop version
  hadoopVersion = '2.6.0'
  # The Zookeeper version
  zookeeperVersion = '3.4.6'
  # The HBase version
  hbaseVersion = '1.1.0'
  # Phoenix version
  phoenixVersion = '4.3.1'
  # The Sqoop version
  sqoopVersion = '1.99.6'
  # The Hive version
  hiveVersion = '1.1.0'
  # The Pig version
  pigVersion = '0.14.0'
  # The cluster will be raised on a private network form the non-addressable set
  baseIp = '192.168.66.'
  # The Hadoop base ip
  hadoopBaseIp = baseIp + '6'
  # The Zookeeper base ip
  zookeeperBaseIp = baseIp + '7'
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
  1.upto(zookeeperEnsembleSize) do |index|
    # The nodes are identified as zookeeper-*
    nodeName = 'zookeeper-' + index.to_s

    config.vm.define nodeName do |node|
      # The nodes are placed at 192.168.66.7*
      node.vm.network :private_network, ip: zookeeperBaseIp + index.to_s

      externalPort = '2421' + index.to_s

      node.vm.network :forwarded_port, guest: 2181, host: externalPort.to_i

      # The nodes are called zookeeper-*.cluster.lab
      node.vm.hostname = 'zookeeper-' + index.to_s

      # start the actual provisioning
      node.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'zookeeper.pp'
        puppet.module_path    = 'puppet/modules'
        puppet.options        = '--verbose'
        puppet.facter         = {
          'user'                    => user,
          'zookeeper_version'       => zookeeperVersion,
          'zookeeper_ensemble_size' => zookeeperEnsembleSize,
          'server_id'               => index,
          'share_path'              => sharePath,
          'base_ip'                 => zookeeperBaseIp
        }
      end
    end
  end

  # Rise the Master which is the default machine
  config.vm.define :master, primary: true do |master|
    # The master is placed at 192.168.66.60
    master.vm.network 'private_network', ip: hadoopBaseIp + '0'
    # NameNode UI
    master.vm.network :forwarded_port, guest: 50070, host: 24200
    # Resource Manager UI
    master.vm.network :forwarded_port, guest: 8088, host: 24201
    # MapReduce JobHistory UI
    master.vm.network :forwarded_port, guest: 19888, host: 24202
    # HBase Master UI
    master.vm.network :forwarded_port, guest: 6010, host: 24203
    # HBase Master Server
    master.vm.network :forwarded_port, guest: 60000, host: 24204
    # Spark Master Server
    master.vm.network :forwarded_port, guest: 8080, host: 24205
    # Spark Tasks
    master.vm.network :forwarded_port, guest: 4040, host: 24206
    # The master is called master.cluster.lab
    master.vm.hostname = 'master'

    master.vm.provider "virtualbox" do |v|
      v.memory = 1024
    end

    # start the actual provisioning of the master
    master.vm.provision :puppet do |puppet|
      puppet.manifests_path = 'puppet/manifests'
      puppet.manifest_file  = 'master.pp'
      puppet.module_path    = 'puppet/modules'
      puppet.options        = '--verbose'
      puppet.facter         = {
        'user'                    => user,
        'hadoop_version'          => hadoopVersion,
        'hbase_version'           => hbaseVersion,
        'spark_version'           => sparkVersion,
        'share_path'              => sharePath,
        'shared_key'              => masterKey,
        'hadoop_cluster_size'     => hadoopClusterSize,
        'zookeeper_ensemble_size' => zookeeperEnsembleSize,
        'hadoop_base_ip'          => hadoopBaseIp,
        'zookeeper_base_ip'       => zookeeperBaseIp,
        'phoenix_version'         => phoenixVersion,
        'sqoop_version'           => sqoopVersion,
        'hive_version'            => hiveVersion,
        'pig_version'             => pigVersion
      }
    end
  end

  # Rise the Data Nodes
  1.upto(hadoopClusterSize) do |index|
    # The slaves are identified as slave-*
    nodeName = 'slave-' + index.to_s

    config.vm.define nodeName do |node|
      # The slaves are placed at 192.168.66.6*
      node.vm.network :private_network, ip: hadoopBaseIp + index.to_s

      externalPort = '2422' + index.to_s

      node.vm.network :forwarded_port, guest: 60030, host: externalPort.to_i

      # The slaves are called slave-*.cluster.lab
      node.vm.hostname = 'slave-' + index.to_s

      node.vm.provider "virtualbox" do |v|
        v.memory = 1024
      end

      # start the actual provisioning
      node.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'puppet/manifests'
        puppet.manifest_file  = 'slave.pp'
        puppet.module_path    = 'puppet/modules'
        puppet.options        = '--verbose'
        puppet.facter         = {
          'user'                    => user,
          'hadoop_version'          => hadoopVersion,
          'spark_version'           => sparkVersion,
          'hbase_version'           => hbaseVersion,
          'share_path'              => sharePath,
          'shared_key'              => masterKey,
          'hadoop_cluster_size'     => hadoopClusterSize,
          'zookeeper_ensemble_size' => zookeeperEnsembleSize,
          'hadoop_base_ip'          => hadoopBaseIp,
          'zookeeper_base_ip'       => zookeeperBaseIp,
          'phoenix_version'         => phoenixVersion
        }
      end
    end
  end

end
