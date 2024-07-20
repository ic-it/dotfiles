# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  fetchedDwmSrc = pkgs.fetchgit { 
    url = "https://github.com/ic-it/dwm.git";
    sha256 = "sha256-DwuA8XjBBMfgFqoBI7nIr9sWMraulA8SA8imk5vJj1I=";
  };
  dwmSrc = if builtins.pathExists /home/icit/dwm then /home/icit/dwm else fetchedDwmSrc.outPath;
in
{
  imports =
    [ 
      <home-manager/nixos>
      ./hardware-configuration.nix
    ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  systemd.user.services.add_ssh_keys = {
    script = ''
      ssh-add $HOME/.ssh/MainKey 
    '';
    wantedBy = [ "multi-user.target" ];  #starts after login
  };
  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bratislava";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sk_SK.UTF-8";
    LC_IDENTIFICATION = "sk_SK.UTF-8";
    LC_MEASUREMENT = "sk_SK.UTF-8";
    LC_MONETARY = "sk_SK.UTF-8";
    LC_NAME = "sk_SK.UTF-8";
    LC_NUMERIC = "sk_SK.UTF-8";
    LC_PAPER = "sk_SK.UTF-8";
    LC_TELEPHONE = "sk_SK.UTF-8";
    LC_TIME = "sk_SK.UTF-8";
  };

  services.dbus.enable = true;
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

#    extraConfig.bluetoothEnhancements = {
#      "monitor.bluez.properties" = {
#        "bluez5.enable-sbc-qt" = true;
#        "bluez5.enable-msbc" = true;
#        "bluez5.enable-hw-volume" = true;
#        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
#      };
#    };
  };

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
    extraConfig = ''
      Section "Monitor"
        Identifier "Virtual-1"
        Option "PreferredMode" "1920x1080"
      EndSection
    '';

    desktopManager.xterm.enable = false;
    displayManager.startx.enable = false;
    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
      greeters.gtk.extraConfig = ''
        [greeter]
        theme-name = IC-IT's lightdm
        icon-theme-name = Papirus-Dark
        font-name = Sans 11
        xft-antialias = true
        xft-hintstyle = hitfull
        xft-rgba = rgb
        show-indicators = ~language;~a11y;~session;~power
      '';
      extraConfig = '''';
    };

    windowManager = { 
      dwm.enable = true;
      dwm.package = pkgs.dwm.overrideAttrs {
        src = dwmSrc;
      };
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.icit = {
    isNormalUser = true;
    description = "ic-it";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
  };

  # Home manager
  home-manager.users.icit = { pkgs, ... }: {
    programs.vim = {
      enable = true;
      settings = { ignorecase = true; };
      extraConfig = ''
        set shiftwidth=4 smarttab
        set expandtab
        set tabstop=4 softtabstop=0
     '';
    };
    programs.zoxide.enable = true;

    home.stateVersion = "24.05";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    unzip

    wezterm
    xclip
    firefox-bin
    vscode
    rofi
    glava
    overskride

    go-task
    stow
    direnv
    eza
    fd
    ripgrep
    feh
    killall
    imagemagick
    keepassxc

    # Fonts
    nerdfonts

    # TMP
    gnome.nautilus
  ];

  programs.fish.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
#  programs.gnupg.agent = {
#    enable = true;
#    enableSSHSupport = true;
#  };
  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.picom = {
    enable = true;
    # backend = "glx";
    fade = true;
    vSync = true;
    settings = {
      glx-no-stencil = true;
      blur = {
        method = "dual_kawase";
        size = 20;
        deviation = 5.0;
      };
    };
    inactiveOpacity = 0.8;
  };

  services.greenclip.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
