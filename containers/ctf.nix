{
  config,
  lib,
  pkgs,
  ...
}:
{
  containers.ctf = {
    autoStart = false; # set true if you want it started at boot
    privateNetwork = true; # share host network by default (change if you want isolation)
    hostAddress = "10.0.0.1";
    localAddress = "10.0.0.100";
    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";

    # bind a host-managed file into the container as /etc/hosts so you can edit hosts "on the go"
    bindMounts = {
      "/etc/hosts" = {
        hostPath = "/var/lib/ctf/hosts"; # create this on the host (see instructions below)
        isReadOnly = false;
      };
      # optional: mount a workspace dir from the host
      "/home/ctf/work" = {
        hostPath = "/home/ouroboros/ctf-work";
        isReadOnly = false;
      };
    };

    enableTun = true;

    # container NixOS configuration (runs inside container)
    config =
      { pkgs, lib, ... }:
      {
        nixpkgs.config.allowUnfree = true;

        users.users.ctf = {
          isNormalUser = true;
          description = "ctf user";
          home = "/home/ctf";
          extraGroups = [ "wheel" ];
          initialPassword = "ctfpassword"; # replace / or use hashedPassword for production
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3SWmxiU6F2gZuIHKV3MmvlCNNYwg+gMW+DUVfcJFeN"
          ];
        };

        # Tools: pentest / reversing / analysis / misc. tweak as you like
        environment.systemPackages = with pkgs; [
          metasploit
          vim
          git
          curl
          openvpn
          wget
          htop
          tmux
          nmap
          netcat-openbsd
          socat
          wireshark-cli
          tcpdump
          binwalk
          foremost
          yara
          radare2
          ghidra
          jadx
          apktool
          python3
          python3Packages.pwntools
          python3Packages.capstone
          gef
          # gdb
          # gdb-with-peda # pwndbg/peda extra (may require manual setup)
          strace
          ltrace
          lsof
          openjdk # for ghidra
          burpsuite # if available in your channel; else install manually
          z3
          ripgrep
          qemu-user
          qemu # run foreign binaries
          docker # optional: run image-based tooling (if you allow)
          # X/VNC bit
          tigervnc
          # xvfb

          xorg.xinit
          xorg.xauth
          # xfce.xfce4
          xfce.xfce4-terminal
          xfce.xfce4-panel
        ];

        # make sure xinit is available (fixes "xinit not found" from vnc wrappers)
        environment.pathsToLink = [ "/run/opengl-driver" ]; # helpful for mesa if hardware/software GL needed

        # create the VNC xstartup file and set ownership
        systemd.tmpfiles.rules = [
          # Ensure .vnc directory and xstartup exist and are owned by ctf
          "d /home/ctf/.vnc 0700 ctf ctf -"
          "f /home/ctf/.vnc/xstartup 0755 ctf ctf -"
        ];
        # drop a simple xstartup; tigervnc will run it when session starts
        environment.etc."vnc-xstartup".text = ''
          #!/bin/sh
          unset SESSION_MANAGER
          unset DBUS_SESSION_BUS_ADDRESS
          xrdb $HOME/.Xresources 2>/dev/null || true
          startxfce4 &
        '';

        # A small systemd service to start a persistent TigerVNC session for user `ctf`
        systemd.services.tigervnc-ctf = {
          description = "TigerVNC server for ctf user";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          serviceConfig = {
            Type = "simple";
            User = "ctf";
            Environment = "HOME=/home/ctf";
            # use vncserver wrapper from tigervnc which launches an Xvnc session and runs ~/.vnc/xstartup
            ExecStart = "${pkgs.tigervnc}/bin/vncserver :1 -geometry 1920x1080 -depth 24 -localhost";
            ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        # Allow ssh inside container (handy for port forwarding to VNC)
        services.openssh.enable = true;
        services.openssh.passwordAuthentication = true;

        # minimal journald logging
        services.journald.extraConfig = ''
          SystemMaxUse=50M
        '';

        # security / sandboxing: tune as you like (we're not blocking outbound network)
        security.sudo.wheelNeedsPassword = false;

        # convenience: basic locale
        i18n.defaultLocale = "en_US.UTF-8";

        # housekeeping
        system.stateVersion = lib.mkDefault "25.05";

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [
              80
              5901
            ];
          };
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };
        services.resolved.enable = true;

      };

  };

}
