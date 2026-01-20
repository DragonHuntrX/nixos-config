#ronm Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  # pkgsnm = import (fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73.tar.gz";
  #   sha256 = "0vx2pw69if88nkfh74bf1a8s5497n2nv7wydmvmqh5qh00fsahvq";
  # }) { system = "x86_64-linux"; };

  # my-nm = pkgsnm.networkmanager;
in
{
  imports = [
    # Include the results of the hardware scan.
    #
  ];

  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.hosts = {
    "10.0.0.1" = [ "www.routerlogin.net" ];
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Apparently wireshark must be enabled at system level
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };
  services.udev = {
    extraRules = ''
      SUBSYSTEM=="usbmon", GROUP="wireshark", MODE="0640"
            SUBSYSTEM=="dumpcap", GROUP="wireshark", MODE="0640" '';
  };

  # STEAM
  xdg.portal.enable = true;
  programs.steam = {
    protontricks.enable = true;
    enable = true;
  };

  # Force wpa_supplicant to use old openssl
  # nixpkgs.config.permittedInsecurePackages = [
  #   "openssl-1.1.1w"
  # ];
  # nixpkgs.overlays = [
  #   (self: super: {
  #     wpa_supplicant = super.wpa_supplicant.override {
  #       openssl = super.openssl_1_1;
  #     };
  #   })
  # ];

  # Enable networking
  networking.networkmanager.enable = true;

  services.cryptography.policies.policy = "LEGACY";

  services.openvpn.servers = {
    cnsVPN = {
      config = "config /root/nixos/openvpn/cns.ovpn";
      updateResolvConf = true;
      autoStart = false;
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  virtualisation.waydroid.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  users.extraGroups.plugdev = { };

  services.udev.packages = [ pkgs.openocd ];

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # services.signald = {
  #   enable = true;
  #   user = "ouroboros";
  # };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # services.ollama = {
  #   enable = true;
  #   acceleration = "cuda";
  #   # Optional: preload models, see https://ollama.com/library
  #   loadModels = [
  #     "deepseek-r1:14b"
  #   ];
  # };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ouroboros = {
    isNormalUser = true;
    description = "Ouroboros";
    extraGroups = [
      "libvirtd"
      "networkmanager"
      "wheel"
      "audio"
      "dialout"
      "wireshark"
      "vboxusers"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "ouroboros"
  ];
  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    openssl
    helix
    nil
    nixd
    git
    zsh
    firefox
    mesa

    # virtualbox
    wireshark

    # my-nm

    openvpn
    networkmanager-openvpn
    waydroid

    playerctl
    wireplumber

    vulkan-tools

    (pkgs.lutris.override {
      extraPkgs = pkgs: [
        pkgs.wineWowPackages.stagingFull
        pkgs.winetricks
      ];

    })

    wine-wayland
    wine64
    winetricks

    # gnomeExtensions.pop-shell
    # gnomeExtensions.wallpaper-slideshow
  ];

  environment.shells = with pkgs; [ zsh ];
  programs.zsh.enable = true;

  # Enable 1Password CLI and GUI
  programs._1password = {
    enable = true;
  };
  programs._1password-gui = {
    enable = true;
    # Enable PolKit for GUI access
    polkitPolicyOwners = [ "ouroboros" ];
  };

  security.polkit.enable = true;

  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "FiraCode" ]; })
  #   fira-code
  # ];
  #
  # fonts.packages = with pkgs; [
  #   nerd-fonts.fira-code
  #   nerd-fonts.noto
  # ];

  fonts.packages =
    [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    80
    7070
  ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
