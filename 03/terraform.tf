# VARIABLES
variable "ARM_SUBSCRIPTION_ID" {}

variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}
variable "ARM_ENVIRONMENT" {}
variable "private_key_path" {}

# PROVIDERS
provider "azurerm" {
  client_id       = "${var.ARM_CLIENT_ID}"
  environment     = "${var.ARM_ENVIRONMENT}"
  subscription_id = "${var.ARM_SUBSCRIPTION_ID}"
  tenant_id       = "${var.ARM_TENANT_ID}"
  alias           = "arm-1"
}

# RESOURCES
resource "azurerm_resource_group" "costa-blog-posts" {
  name     = "costa-blog-posts"
  location = "West Europe"
}

resource "azurerm_virtual_network" "network" {
  name                = "network"
  address_space       = ["10.0.0.0/16"]
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.costa-blog-posts.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = "${azurerm_resource_group.costa-blog-posts.name}"
  virtual_network_name = "${azurerm_virtual_network.network.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "publicIP" {
  name                = "publicIP"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.costa-blog-posts.name}"
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "security-group" {
  name                = "security-group"
  location            = "West Europe"
  resource_group_name = "${azurerm_resource_group.costa-blog-posts.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1020
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "network-interface" {
  name                      = "network-interface"
  location                  = "West Europe"
  resource_group_name       = "${azurerm_resource_group.costa-blog-posts.name}"
  network_security_group_id = "${azurerm_network_security_group.security-group.id}"

  ip_configuration {
    name                          = "nicConfiguration"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.publicIP.id}"
  }
}

resource "azurerm_virtual_machine" "virtual-machine" {
  name                  = "virtual-machine"
  location              = "West Europe"
  resource_group_name   = "${azurerm_resource_group.costa-blog-posts.name}"
  network_interface_ids = ["${azurerm_network_interface.network-interface.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04.0-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = "${file(var.private_key_path)}"
    }
  }

  #  provisioner "remote-exec" {
  #   inline = [
  #       "sudo apt update",
  #       "sudo apt install nginx -y",
  #       "sudo ufw allow 'Nginx HTTP'",
  #       "sudo service nginx start"
  #   ]
  # }
}



# OUTPUT

