packer {
  required_plugins {
    virtualbox = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "ubuntu" {
  guest_os_type    = "Ubuntu_64"
  iso_url          = "https://cdimage.ubuntu.com/releases/focal/release/ubuntu-20.04.5-live-server-amd64.iso"
  iso_checksum     = "md5:92e9cf0851b78ad4c015563f1b6187b3"
  ssh_username     = "packer"
  ssh_password     = "packer"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
}

/* source "virtualbox-vm" "ubuntu" {
  boot_command = [
    "<enter><enter><f6><esc><wait> ",
    "autoinstall ds=nocloud-net;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<enter><wait>"
  ]
  boot_wait            = "4s"
  guest_additions_path = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type        = "Ubuntu_64"
  headless             = false
  http_directory       = "http"
  iso_checksum         = "92e9cf0851b78ad4c015563f1b6187b3"
  iso_checksum_type    = "md5"
  iso_urls = [
    "iso/ubuntu-20.04.5-live-server-arm64.iso",
    "https://cdimage.ubuntu.com/releases/focal/release/ubuntu-20.04.5-live-server-arm64.iso"
  ]
  shutdown_command        = "echo 'shutdown -P now' > shutdown.sh; echo 'vagrant'|sudo -S sh 'shutdown.sh'"
  ssh_password            = "vagrant"
  ssh_port                = 22
  ssh_username            = "vagrant"
  ssh_wait_timeout        = "10000s"
  vboxmanage              = [["modifyvm", "{{ .Name }}", "--memory", "2048"], ["modifyvm", "{{ .Name }}", "--cpus", "4"]]
  virtualbox_version_file = ".vbox_version"
} */

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    scripts = ["scripts/root.sh"]
  }

  provisioner "shell" {
    scripts = ["scripts/setup.sh"]
  }

  post-processor "vagrant" {
  }
}
