## Configure the vSphere Provider
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

## Build VM
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

variable "vm_nodes" {
  type = map(object({
    cpu        = number
    memory     = number
    disk_size  = number
    ip_address = string
  }))
  default = { # Set the vCPU quantity (at least 2), memory size (in MB, at least 2048), disk size (in GB) and IP address for each machine
    "k8s-master-1" = { cpu = 2, memory = 2048, disk_size = 22, ip_address = "xxx.xxx.xx.1" }
    "k8s-master-2" = { cpu = 2, memory = 2048, disk_size = 22, ip_address = "xxx.xxx.xx.2" }
    "k8s-master-3" = { cpu = 2, memory = 2048, disk_size = 22, ip_address = "xxx.xxx.xx.3" }
    "k8s-worker-1" = { cpu = 2, memory = 2048, disk_size = 22, ip_address = "xxx.xxx.xx.4" }
    "k8s-worker-2" = { cpu = 2, memory = 2048, disk_size = 22, ip_address = "xxx.xxx.xx.5" }
  }
}

resource "vsphere_virtual_machine" "k8s_nodes" {
  for_each        = var.vm_nodes
  name            = each.key
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id    = data.vsphere_datastore.datastore.id

  num_cpus = each.value.cpu
  memory   = each.value.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  wait_for_guest_net_timeout = 0

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "vmxnet3" # Set the type of network adapter 
#   adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]  # In case you want to use the same network adapter as template 
  }

  disk {
    label            = "disk0"
    size             = each.value.disk_size
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = each.key
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = each.value.ip_address
        ipv4_netmask = var.vm_netmask
      }

      ipv4_gateway = var.vm_gateway
    }
  }
}
