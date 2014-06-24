# Launch a Hadoop cluster on your own workstation

![Mou icon](http://upload.wikimedia.org/wikipedia/commons/0/0e/Hadoop_logo.svg)

> **Hadoop 2.4** fully **distributed cluster** with **only 3 dependencies**

## Overview

Use this ready-made cluster as your starting point to experimenting with Hadoop 2.4. You have total freedom in modifying it to match your needs while having a solid foundation to start with.

## Quick start

You'll need about **6 GB of RAM** in the default configuration. The cluster was tested on **Linux**, **Mac OS** and **Windows**.

##### Dependencies

1. [Vagrant](http://www.vagrantup.com/downloads.html)
2. [Git](http://git-scm.com/downloads)
3. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

*Virtualization needs to be enabled in BIOS. You probably have this enabled, but if things go awry, this might be the problem.*

##### Installation

* Open a new terminal.
* Download the configuration by issuing `git clone git@github.com:cosmincatalin/hadoop-cluser.git`.
* Go into the **hadoop-cluster** directory.
* Issue the magical `vagrant up`
* Go make yourself a tea, it can take anywhere between 10 minutes to 40 minutes, depending on your internet connection speed.
* Cluster is ready waiting for something to do.

## The long story

For whomever wants to understand what actually goes on behind the scenes, here is an explanation of the software stack and the architecture of which the Hadoop cluster is made of.

#### VirtualBox

VirtualBox is a popular software package used for creating virtual machines. It is **free to use** and exposes an API for working with it. VirtualBox is the foundation of the Hadoop cluster.

##### Vagrant

Vagrant is an utility that leverages the API of VirtualBox for the creation of virtual machines. Vagrant can be plugged in with different *provisioners* that configure the virtual machines.

##### Puppet

Enter Puppet, which is currently the de-facto industry standard for system configuration automation. Vagrant uses the power of Puppet to configure the Hadoop cluster. Puppet is a **Ruby DSL**