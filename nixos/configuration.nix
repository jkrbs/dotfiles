# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./modules/development.nix
    ./modules/i3.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "alundra"; # Define your hostname.
  networking.wireless.enable =
    true; # Enables wireless support via wpa_supplicant.
  networking.wireless.interfaces = [ "wlp59s0" ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  location.provider = "manual";
  # using the location of the cafe ascii should be good enough
  location.latitude = 51.0250869;
  location.longitude = 13.7210005;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp59s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  programs.evince.enable = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    # the full package is necessary for BT support
    package = pkgs.pulseaudioFull;
    # switch to bluetooth automatically if they are connected
    extraConfig =
      "\n      load-module module-switch-on-connect\n      load-module module-bluetooth-policy auto_switch=2\n    ";
  };
  nixpkgs.config.pulseaudio = true;

  # enable bluetooth in general and add a simple tool for connecting devices
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
    # enable A2DP
    settings = {
      General = {
        Enable = "Source,Sink,Media";
        Disable = "Socket";
      };
    };
  };
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.udisks2.enable = true;
  programs.gnome-disks.enable = true;
  services.openvpn = {
    servers.vpn-krbs-me = {
      autoStart = true;
      config = " config /home/openvpn/alundra.ovpn";
    };
  };
  users.users.jakob = {
    isNormalUser = true;
    createHome = true;
    home = "/home";
    shell = pkgs.zsh;
    extraGroups = [
      "uucp"
      "video"
      "dbus"
      "libvirtd"
      "wheel"
    ]; # Enable ‘sudo’ for the user.
  };
  # periodic automated mail fetching
  systemd.user.services.mailfetch = {
    enable = true;
    description = "Automatically fetches for new mail when the network is up";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Restart = "always";
      RestartSec = "60";
    };
    path = with pkgs; [ bash notmuch isync ];
    script = ''
      mbsync -a && notmuch new
    '';
  };

  services.pipewire.enable = true;
  hardware.video.hidpi.enable = true;
  services.xserver = {
    enable = true;
    displayManager = {
      sddm = { enable = true; };
      defaultSession = "sway";
    };

    desktopManager.plasma5.enable = true;
    dpi = 80;
  };
  services.gnome.gnome-keyring.enable = true;
  services.pipewire.media-session.enable = true;
  programs.light.enable = true;
  services.actkbd = {
    enable = true;
    bindings = [
      {
        keys = [ 225 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -A 10";
      }
      {
        keys = [ 224 ];
        events = [ "key" ];
        command = "/run/current-system/sw/bin/light -U 10";
      }
    ];
  };
  nixpkgs.config.allowUnfree = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  programs.dconf.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.homeBinInPath = true;
  environment.systemPackages = with pkgs; [
    vimHugeX # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    vim
    wget
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    spotify
    watson
    mumble

    irony-server
    youtube-dl
    element-desktop
    mpv
    sqlite
    streamlink
    ffmpeg-full
    virt-manager
    bash
    killall
    lyx
    ## file managers
    ranger
    gnome.nautilus
    ## document viewers
    mupdf
    perl
    ncurses
    pkg-config
    pdfpc
    wl-clipboard
    wdisplays
    zathura
    ## PDF manipulation
    podofo
    poppler_utils
    ## image manipulation
    gimp
    inkscape
    nextcloud-client
    libheif
    ## LaTeX
    texlive.combined.scheme-full
    ## the eternal pain continues
    libreoffice-fresh

    ## I heard you like man pages?
    man-pages
    w3m
    htop
    bat
    lsd
    ripgrep
    sshfs
    ncdu
    tldr
    unzip
    ncat
    bind
    inetutils
    usbutils
    screen
    moreutils
    file
    ## audio management
    obs-studio
    pavucontrol
    ## password management
    pass
    pinentry-curses
    rbw
    ## mail
    isync
    msmtp
    neomutt
    urlview
    bitwarden
    notmuch
    weechat
    python3
    ispell
    evince
    emacs
    vscode-fhs
    nixfmt
    sublime3
    firefox
    firefox-wayland
    tdesktop
    gnupg
    pass

  ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      waybar
      restic
      alacritty
      dmenu
      kanshi
    ];
  };
  programs.waybar.enable = true;
  fonts.fonts = with pkgs; [
    font-awesome
    fira
    fira-code
    fira-code-symbols
    noto-fonts
    noto-fonts-cjk
    noto-fonts-extra
    roboto
    roboto-mono
    roboto-slab
    open-sans
    overpass
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "DroidSansMono"
        "Hack"
        "SourceCodePro"
        "RobotoMono"
        "Ubuntu"
        "UbuntuMono"
      ];
    })
  ];

  services.redshift = {
    enable = true;
    # Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
    package = pkgs.redshift-wlr;
    temperature.night = 3500;
  };

  systemd.user.targets.sway-session = {
    description = "Sway compositor session";
    documentation = [ "man:systemd.special(7)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
  };

  systemd.user.services.sway = {
    description = "Sway - Wayland window manager";
    documentation = [ "man:sway(5)" ];
    bindsTo = [ "graphical-session.target" ];
    wants = [ "graphical-session-pre.target" ];
    after = [ "graphical-session-pre.target" ];
    # We explicitly unset PATH here, as we want it to be set by
    # systemctl --user import-environment in startsway
    environment.PATH = pkgs.lib.mkForce null;
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
      '';
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.user.services.swayidle = {
    description = "Idle Manager for Wayland";
    documentation = [ "man:swayidle(1)" ];
    wantedBy = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    path = [ pkgs.bash ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.swayidle}/bin/swayidle -w -d \
               timeout 300 '${pkgs.sway}/bin/swaymsg "output * dpms off"' \
               resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
             '';
    };
  };

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      # kanshi doesn't have an option to specifiy config file yet, so it looks
      # at .config/kanshi/config
      ExecStart = ''
        ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
