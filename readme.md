## Launch a Big-Data cluster on your own workstation

![Hbase logo](http://archive.cloudera.com/cdh4/cdh/4/hbase-0.94.2-cdh4.2.0/images/hbase_logo.png)

> **HBase 0.98.3** fully **distributed cluster** with **only 3 dependencies**

## Wiki

A wiki of this project can be found [here](https://github.com/cosmincatalin/hbase-cluster/wiki)

## Overview

Use this ready-made cluster as your starting point to experimenting with Big-Data technologies. You have total freedom in modifying it to match your needs while having a solid foundation to start with.

## Quick start

You'll need about **11 GB of RAM** in the default configuration. 7 virtual machines will be created. The cluster was tested on **Linux**, **Mac OS** and **Windows**.

##### Dependencies

1. [Vagrant](http://www.vagrantup.com/downloads.html)
2. [Git](http://git-scm.com/downloads)
3. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

*Virtualization needs to be enabled in BIOS. You probably have this enabled, but if things go awry, this might be the problem.*

##### Installation

* Open a new terminal.
* Download the configuration by issuing `git clone git@github.com:cosmincatalin/hbase-cluster.git` (or `git clone https://github.com/cosmincatalin/hbase-cluster.git` if you don't have an ssh agent running).
* Go into the **hbase-cluster** directory.
* Issue the magical `vagrant up`
* Go make yourself a tea, it can take anywhere between 15 minutes to 40 minutes, depending on your internet connection speed.
* Log in the master `vagrant ssh`
* Log in as the base hduser `sudo su - hduser`
* Start HBase `./hbase/bin/start-hbase.sh`

## The long story

For whomever wants to understand what actually goes on behind the scenes, here is an explanation of the software stack and the architecture of which the Hadoop cluster is made of.

##### VirtualBox

VirtualBox is a popular software package used for creating virtual machines. It is **free to use** and exposes an API for working with it. VirtualBox is the foundation of the Hadoop cluster.

##### Vagrant

Vagrant is an utility that leverages the API of VirtualBox for the creation of virtual machines. Vagrant can be plugged in with different *provisioners* that configure the virtual machines.

##### Puppet

Enter Puppet, which is currently the de-facto industry standard for system configuration automation. Vagrant uses the power of Puppet to configure the Hadoop cluster. Puppet is a **Ruby DSL**.

##### Web Apps

The cluster exposes three web applications that can help when working with Hadoop and HBase:

* NameNode - [http://localhost:24200](http://localhost:24200)
* Task Manager - [http://localhost:24201](http://localhost:24201)
* Job History Manager - [http://localhost:24202](http://localhost:24202)
* HBase master - [http://localhost:24203](http://localhost:24203)
 
##### Working with the cluster

If you actually want to work with the cluster from outside its environment (Eg: run an HBase enabled Java application from your host, connect to Phoenix via JDBC etc.) you will nedd to configure your `hosts` configuration file.

```
192.168.66.71   zookeeper-1
192.168.66.71   zookeeper-2
192.168.66.71   zookeeper-3
192.168.66.60   master
192.168.66.61   slave-1
192.168.66.62   slave-2
192.168.66.63   slave-3
```


##### What's included

* Hadoop 2.4.0
* Zookeeper 3.4.6
* HBase 0.98.3
* Phoenix 4.0.0
* Sqoop 1.4.4
* Hive 0.13.1

##### Feedback

Please don't hesistate to provide feedback.
