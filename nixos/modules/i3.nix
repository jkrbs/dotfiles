{ config, lib, pkgs, ... }:

{
  # Configure X Server
  services.xserver.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      dmenu
      #(i3status-rust.overrideAttrs ( oldAttrs: { cargoBuildFlags = [ "--features=notmuch" ]; }))
      i3status-rust
      i3lock-fancy
      libnotify
      dunst
      feh
      scrot
      kitty
      ## automatic detection of display changes
      autorandr
      xss-lock
    ];
    # extraSessionCommands = "feh --bg-scale /home/felix/wall.jpg";
  };

  services.xserver.xautolock = {
    enable = true;
    extraOptions = [ "-detectsleep" ];
    locker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    nowlocker = "${pkgs.i3lock-fancy}/bin/i3lock-fancy";
    time = 10;
  };

}
