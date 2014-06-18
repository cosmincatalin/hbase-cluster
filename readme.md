# Hadoop 2.4 cluster with Vagrant and Puppet

> **Hadoop 2.4** fully **distributed cluster** with **only 3 dependencies**

## Overview

Use the **Vagrant** configuration in this repository to luanch a **Hadoop 2.4** cluster on your own machine. The cluster is currently composed of one Master Node and 3 Data Nodes.

## Quick start

To get started, you'll need a guest operating system. I recommend using **Ubuntu** or **Mac OS**, on which I have tested the configuration myself. If you have **Windows** I can only wish you good luck (pull requests are welcome).

###### Dependencies

1. [Vagrant](http://www.vagrantup.com/downloads.html)
2. [Git](http://git-scm.com/downloads)
3. [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

*Virtualization needs to be enabled in BIOS. You probably have this enabled, but if things go awrey, this might be the problem.*

###### Start the cluster

* Open a new terminal.
* Download the configuration by issuing `git clone git@github.com:cosmincatalin/hadoop-cluser.git`.
* Go into the **hadoop-cluster** directory.
* Issue the magical `vagrant up`
* Go make yourself a tea
* After a few minutes you should have a Hadoop cluster running on your own machine.

## The long story

...to arrive later