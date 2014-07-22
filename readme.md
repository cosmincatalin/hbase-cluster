## Launch an HBase cluster on your own workstation

> **HBase 0.98.3** fully **distributed cluster** with **only 3 dependencies**

## What's included


![Hadoop logo](http://upload.wikimedia.org/wikipedia/commons/0/0e/Hadoop_logo.svg =200x)
![Hbase logo](http://archive.cloudera.com/cdh4/cdh/4/hbase-0.94.2-cdh4.2.0/images/hbase_logo.png =180x)
![Phoenix logo](https://camo.githubusercontent.com/a5df2809ea1d2fb8d5f6ea75693d1db9afb291f0/687474703a2f2f666f726365646f74636f6d2e6769746875622e636f6d2f70686f656e69782f696d616765732f6c6f676f2e6a7067 =150x)
![Sqoop logo](http://sqoop.apache.org/images/sqoop-logo.png =200x)

![Hive logo](http://hive.apache.org/images/hive_logo_medium.jpg =130x)
![Zookeeper logo](https://svn.apache.org/repos/asf/zookeeper/logo/zookeeper.jpg =100x)

* Hadoop 2.4.0
* HBase 0.98.3
* Zookeeper 3.4.6
* Phoenix 4.0.0
* Sqoop 1.4.4
* Hive 0.13.1

## Overview

Use this ready-made cluster as your starting point to experimenting with HBase 0.98.3. You have total freedom in modifying it to match your needs while having a solid foundation to start with.

## Quick start

You'll need about **8 GB of RAM** in the default configuration. 7 virtual machines will be created. The cluster was tested on **Linux**, **Mac OS** and **Windows**.

##### Dependencies

1. [Vagrant](http://www.vagrantup.com/downloads.html)
2. [Git](http://git-scm.com/downloads)
3. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

*Virtualization needs to be enabled in BIOS. You probably have this enabled, but if things go awry, this might be the problem.*

##### Installation

* Open a new terminal.
* Download the configuration by issuing `git clone git@github.com:cosmincatalin/hbase-cluster.git`.
* Go into the **hbase-cluster** directory.
* Issue the magical `vagrant up`
* Go make yourself a tea, it can take anywhere between 15 minutes to 40 minutes, depending on your internet connection speed.
* Cluster is ready waiting for something to do.

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

##### Feedback

Please don't hesistate to provide feedback.
