_: {
  flake.nixosModules.kernel =
    { lib, pkgs, ... }:
    {
      boot.kernel.sysctl = {
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "net.ipv4.tcp_fin_timeout" = 5;
        "kernel.split_lock_mitigate" = 0;
        "vm.max_map_count" = 2147483642;
      };
    };
}
