terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.2.0"
    }
  }
}

provider "vsphere" {
  vsphere_server       = var.esxi_server
  user                 = var.esxi_user
  password             = var.esxi_password
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "ha-datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.esxi_server
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.network_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count            = 7
  name             = "${var.vm_name}-${count.index + 1}"
  resource_pool_id = data.vsphere_host.host.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 5
  memory   = 4096
  guest_id = "other3xLinux64Guest"

  wait_for_guest_net_timeout = 0

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "e1000"
  }

  disk {
    label = "disk0"
    size  = 20
  }

  cdrom {
    datastore_id = data.vsphere_datastore.datastore.id
    path         = "ISO/Rocky-10.0-x86_64-dvd1.iso"
  }
}