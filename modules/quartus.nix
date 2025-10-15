{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Where you installed Quartus 20.x
  quartus20Home = "~/intelFPGA_lite/20.1"; # %h expands to $HOME in systemd; here just a hint
  quartus20FHS = pkgs.buildFHSEnv {
    name = "quartus20-fhs";
    targetPkgs =
      p: with p; [
        coreutils
        bash
        firefox
        # common 64-bit libs Quartus/Java/Tk bits may touch
        zlib
        glibc
        glib
        libxml2
        fontconfig
        freetype
        libnsl
        ncurses5
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXtst
        xorg.libXi
        xorg.libXft
        xorg.libSM
        xorg.libICE
        libxcrypt-legacy
        gtk2
        alsa-lib
      ];
    # 32-bit side for ModelSim Starter (20.x era)
    multiPkgs =
      p: with p.pkgsi686Linux; [
        glibc
        glibc.dev

        glib
        stdenv
        ncurses5
        zlib
        zlib.dev
        libuuid
        libnsl
        libtool
        fontconfig
        freetype
        libx11
        xorg.libX11
        xorg.libXext
        xorg.libXrender
        xorg.libXtst
        xorg.libXi
        xorg.libXft
        xorg.libSM
        xorg.libICE
        xorg.libXt
        xorg.libXcursor
        libxcrypt-legacy
        alsa-lib
        gtk2
        libxml2
      ];

    profile = ''
      export LD_LIBRARY_PATH="/lib32:/lib:/usr/lib"
    '';
    runScript = ''
      # ${quartus20Home}/quartus/bin/quartus
      /bin/bash
    '';
  };
in
{
  environment.systemPackages = [ quartus20FHS ];
  # udev: from §3
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6001", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6002", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6003", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6010", TAG+="uaccess"
    SUBSYSTEM=="usb", ATTR{idVendor}=="09fb", ATTR{idProduct}=="6810", TAG+="uaccess"
  '';
}
