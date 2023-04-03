provider "vsphere" {
  user     = "administrator@vsphere.local"
  password = "********"
  vsphere_server = "ip-vsphere"

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
  name          = "ip-host"
  datacenter_id         = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Template_CentOS_Stab"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


# ========================Deploy VM Apache-1===========================================

resource "vsphere_virtual_machine" "Apache-1-TR" {
  name             = "Apache-1-TR"
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
        host_name = "apache-1-tr"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address = "10.33.133.70" 
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
     host        = "10.33.133.70"
     type        = "ssh"
     user        = "root"
     password = "*******"
     }

   }

 }


# ========================Deploy VM Apache-2===========================================

resource "vsphere_virtual_machine" "Apache-2-TR" {
  name             = "Apache-2-TR"
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
        host_name = "apache-2-tr"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address = "10.33.133.71" 
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
     host        = "10.33.133.71"
     type        = "ssh"
     user        = "root"
     password = "*******"
     }

   }

 }

# ========================Deploy VM Apache-3===========================================

 resource "vsphere_virtual_machine" "Apache-3-TR" {
  name             = "Apache-3-TR"
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
        host_name = "apache-3-tr"
        domain    = "mcorp.kz"
      }
      dns_server_list     = ["10.33.130.11", "10.25.130.11"]
  
      network_interface {
        ipv4_address = "10.33.133.72" 
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
     host        = "10.33.133.72"
     type        = "ssh"
     user        = "root"
     password = "*******"
     }

   }

 }

 
# ========================Deploy VM HAProxy===========================================

resource "vsphere_virtual_machine" "HAProxy-TR" {
  name             = "HAProxy-TR"
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
        host_name = "haproxy-tr"
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
     password = "*******"
     }

   }

 }

# ========================Deploy VM Ansible===========================================

 resource "vsphere_virtual_machine" "Ansible-TR" {
  name             = "Ansible-TR"
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
        host_name = "ansible-tr"
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
      "echo [defaults] > /etc/ansible/ansible.cfg",
      "echo host_key_checking = False >> /etc/ansible/ansible.cfg",
      "echo inventory = /etc/ansible/hosts >> /etc/ansible/ansible.cfg", 
      
      ]
     connection {
     host        = "10.33.133.74"
     type        = "ssh"
     user        = "root"
     password = "*******"
     }

   }

 }

