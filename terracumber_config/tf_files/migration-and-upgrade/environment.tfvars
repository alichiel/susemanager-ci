ENVIRONMENT_CONFIGURATION = {
  ales = {
    mac = {
      controller     = "aa:b2:93:01:01:a4"
      server         = "aa:b2:93:01:01:a5"
      proxy          = "aa:b2:93:01:01:a6"
      suse-client    = "aa:b2:93:01:01:a7"
      suse-minion    = "aa:b2:93:01:01:a8"
      suse-sshminion = "aa:b2:93:01:01:a9"
      rhlike-minion  = "aa:b2:93:01:01:aa"
      deblike-minion = "aa:b2:93:01:01:ab"
      build-host     = "aa:b2:93:01:01:ac"
      kvm-host       = "aa:b2:93:01:01:ad"
    }
    hypervisor          = "suma-05.mgr.suse.de"
    pool                = "amarecek_disks"
    bridge              = "br0"
    additional_network  = "192.168.19.0/24"
    dhcp_user           = "root"
  }
}
