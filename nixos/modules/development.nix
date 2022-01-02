{ config, lib, pkgs, ... }:

{
  #tftp server for booting embedded devices
  services.tftpd.enable = true;
  services.tftpd.path = "/home/tftpdroot";

  #udev rules for salae logic analyser
  services.udev = {
    packages = [
      (pkgs.writeTextFile {
        name = "saleae_udev";
        text = ''
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1001", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1003", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1004", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1005", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="21a9", ATTR{idProduct}=="1006", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="3881", ATTR{idProduct}=="0925", MODE="0666"
          SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666"
        '';
        destination = "/etc/udev/rules.d/50-saleae.rules";
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    # c, c++ compilers and dev tools
    gcc
    clang
    clang-tools
    libtool
    libclang
    dialog
    binutils-unwrapped
    gnumake
    cmake
    gdb
    valgrind
    heaptrack

    # openssl and lib for development
    openssl
    openssl.dev

    #uboot for building images
    ubootTools

    ## git and friends
    git
    gitAndTools.delta
    gitAndTools.gitui
    vim

    ## programming languages and compilers
    rustup
    cargo-flamegraph
    cargo-watch
    iputils

  ];
}
