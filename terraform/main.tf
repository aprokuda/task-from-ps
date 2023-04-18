provider "vsphere" {
  user     = "administrator@vsphere.local"
  password = "******"
  vsphere_server = "10.33.128.100"

  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name                 = "Datacenter"
}

data "vsphere_datastore" "datastore" {
  name                  = "vDisk-ESXi-1"
  datacenter_id         = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "CO-HP-BladeSystem"
  datacenter_id         = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VLAN133"
  datacenter_id         = data.vsphere_datacenter.datacenter.id
}
 
data "vsphere_host" "host" {
  name          = "10.33.128.26"
  datacenter_id         = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Template-CentOS-SSHKey"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


# ======================== Deploy VM Apache ===========================================


locals {
  ip_addresses = ["10.33.133.70", "10.33.133.71", "10.33.133.72"]
}

resource "vsphere_virtual_machine" "apache-tf" {
  count            = 3
  name             = "apache-${count.index+1}-tf"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
    
  num_cpus = 2
  memory   = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id 
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = false
  }

clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "apache-${count.index+1}-tf"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address =  element(local.ip_addresses, count.index) 
        ipv4_netmask = 24
      }
 
      ipv4_gateway = "10.33.133.1"
    }
  }

provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "echo network: {config: disabled} >> /etc/cloud/cloud.cfg", 
      ]
     connection {
     host        = element(local.ip_addresses, count.index)
     type        = "ssh"
     user        = "root"
     private_key = file("~/.ssh/id_rsa")
     }

   }

 }

 
# ========================Deploy VM HAProxy===========================================

resource "vsphere_virtual_machine" "haproxy-tf" {
  name             = "haproxy-tf"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
    
  num_cpus = 2
  memory   = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id 
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = false
  }

clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "haproxy-tf"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address = "10.33.133.73" 
        ipv4_netmask = 24
      }
 
      ipv4_gateway = "10.33.133.1"
    }
    
  }

provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "echo network: {config: disabled} >> /etc/cloud/cloud.cfg", 
      ]
     connection {
     host        = "10.33.133.73"
     type        = "ssh"
     user        = "root"
     private_key = file("~/.ssh/id_rsa")
     }

   }

 }

# ========================Deploy VM Ansible===========================================

 resource "vsphere_virtual_machine" "ansible-tf" {
  name             = "ansible-tf"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id = data.vsphere_datastore.datastore.id
    
  num_cpus = 2
  memory   = 4096
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id = data.vsphere_network.network.id 
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = false
  }

clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "ansible-tf"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address = "10.33.133.74" 
        ipv4_netmask = 24
      }
 
      ipv4_gateway = "10.33.133.1"
    }

    
  }

provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "echo network: {config: disabled} >> /etc/cloud/cloud.cfg",
      "yum -y install epel-release",
      "yum -y install ansible",
      
      ]
     connection {
     host        = "10.33.133.74"
     type        = "ssh"
     user        = "root"
     private_key = file("~/.ssh/id_rsa")
     }

   }

provisioner "file" {
    source      = "C:/Terraform/project-tr/ansible"
    destination = "/etc/"
     connection {
     host        = "10.33.133.74"
     type        = "ssh"
     user        = "root"
     private_key = file("~/.ssh/id_rsa")
     }

   }


provisioner "remote-exec" {
    inline = [
      "ansible-playbook /etc/ansible/playbook-apache.yml",     
      "ansible-playbook /etc/ansible/playbook-haproxy.yml", 
      ]
     connection {
     host        = "10.33.133.74"
     type        = "ssh"
     user        = "root"
     private_key = file("~/.ssh/id_rsa")
     }

   }

}

