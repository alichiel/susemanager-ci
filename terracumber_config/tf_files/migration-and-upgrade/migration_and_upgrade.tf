terraform {
  required_version = ">= 1.6.0"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}

provider "libvirt" {
  uri = "qemu+tcp://${var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].hypervisor}/system"
}

module "cucumber_testsuite" {
  source = "./modules/cucumber_testsuite"

  product_version = var.MAU["product_version"]

  // Cucumber repository configuration for the controller
  git_username = var.GIT_USER
  git_password = var.GIT_PASSWORD
  git_repo     = var.CUCUMBER_GITREPO
  branch       = var.CUCUMBER_BRANCH

  cc_username = var.SCC_USER
  cc_password = var.SCC_PASSWORD

  cc_ptf_username = var.SCC_PTF_USER
  cc_ptf_password = var.SCC_PTF_PASSWORD

  images = ["opensuse160o", "sles15sp6o", "sles15sp7o", "slmicro60o", "slmicro61o"]

  ssh_key_path = var.CONTROLLER_PUBLIC_SSH_KEY_PATH
  use_avahi    = false
  name_prefix   = "${var.ENVIRONMENT}-"
  domain       = "mgr.suse.de"
  from_email   = "root@suse.de"

  no_auth_registry       = "registry.mgr.suse.de"
  auth_registry          = "registry.mgr.suse.de:5000/cucutest"
  auth_registry_username = "cucutest"
  auth_registry_password = "cucusecret"
  git_profiles_repo      = "https://github.com/uyuni-project/uyuni.git#:testsuite/features/profiles/temporary"

  container_server = true
  container_proxy  = true

  mirror                   = "minima-mirror-ci-bv.mgr.suse.de"
  use_mirror_images        = false

  server_http_proxy        = "http-proxy.mgr.suse.de:3128"
  custom_download_endpoint = "ftp://minima-mirror-ci-bv.mgr.suse.de:445"

  ## Add extra containers
  deploy_tftp              = true
  deploy_saline            = true
  deploy_coco_attestation  = true
  deploy_hub_api           = true

  # when changing images, please also keep in mind to adjust the image matrix in the "Used image versions" section of the README.
  host_settings = {
    controller = {
      image = "opensuse160o"
      provider_settings = {
        mac       = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].mac["controller"]
        vcpu = 4
        memory = 4096
      }
    }
    server_containerized = {
      image = var.MAU["os_startpoint"]
      provider_settings = {
        mac = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].mac["server"]
        vcpu = 4
        memory = 16384
      }
      main_disk_size       = 200
      login_timeout        = 28800
      large_deployment     = true
      runtime              = "podman"
      container_registry   = var.MAU["container_registry_startpoint"]
      container_tag        = var.MAU["container_tag_startpoint"]

    }
    proxy_containerized = {
      image = var.MAU["os_startpoint"]
      provider_settings = {
        mac = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].mac["proxy"]
        vcpu = 2
        memory = 4096
      }
      main_disk_size = 200
      runtime = "podman"
      container_registry = var.MAU["container_registry_startpoint"]
      container_tag = var.MAU["container_tag_startpoint"]
    }
    suse_minion = {
      image = "sles15sp7o"
      provider_settings = {
        mac = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].mac["suse-minion"]
        vcpu = 2
        memory = 4096
      }
    }
  }
  provider_settings = {
    pool               = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].pool
    network_name       = null
    bridge             = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].bridge
    additional_network = var.ENVIRONMENT_CONFIGURATION[var.ENVIRONMENT].additional_network
  }
}

output "configuration" {
  sensitive = true
  value     = module.cucumber_testsuite.configuration
}
