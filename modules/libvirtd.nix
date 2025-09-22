{
  pkgs,
  lib,
  config,
  ...
}:
let
  virsh-wrapped = pkgs.writeScriptBin "virsh" ''
    #!${pkgs.bash}/bin/bash
    export LIBVIRT_DEFAULT_URI="qemu:///system"
    exec ${pkgs.libvirt}/bin/virsh "$@"
  '';

in
{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
  environment.systemPackages = [
    pkgs.virt-manager
    pkgs.virt-viewer
    virsh-wrapped
  ];
  environment.variables.PATH = [
    "${virsh-wrapped}/bin"
  ];

}
