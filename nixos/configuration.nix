# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  #TODO: smth related to i3wm config, check
  environment.pathsToLink = [ "/libexec" ];
  environment.sessionVariables = {
	TERMINAL = [ "termite" ];
	# TODO: walkaround show in lxappearance icons
	GDK_PIXBUF_MODULE_FILE = "$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)";
};
  nixpkgs.config = {
    allowUnfree = true;
    oraclejdk.accept_license = true;
    packageOverrides = pkgs: rec {
      polybar = pkgs.polybar.override {
        i3Support = true;
      };
    };
  };

  imports = 
    [
      <nixos-hardware/lenovo/thinkpad/x220>
      /etc/nixos/hardware-configuration.nix
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "pwnx";
  networking.wireless.enable = true;
  networking.dhcpcd = {
    enable = true;
    denyInterfaces = [
      "wwp0s29u1u4i6"
    ];
  };
  
  i18n = {
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Kiev";

  environment.systemPackages = with pkgs; [
    home-manager
    killall
    wget
    vim
    unzip
    unrar
    transmission-remote-cli
# browsers
    firefox
    links
# coding
    maven
    python3
    oraclejdk
    git
# terminal
    termite
# msg
    tdesktop
    slack
# desktop image
    scrot
# buffer
    xclip
    lsof
    pciutils
    feh
    irssi
    pulseaudio
    pamixer
    ponymix
    bc
    upower
# appearance
    plymouth
    numix-cursor-theme
    lxappearance-gtk3
    adapta-gtk-theme 
    deepin.deepin-gtk-theme 
    numix-gtk-theme 
    numix-solarized-gtk-theme 
    numix-sx-gtk-theme
    paper-gtk-theme
    faba-icon-theme
    faba-mono-icons
    numix-icon-theme
    numix-icon-theme-circle
    numix-icon-theme-square
    fontmatrix
    font-manager
# power
    acpi
    powertop
# keyboard layout
    xkb-switch 
    kbdd
    xneur
  ];

  fonts = {
    fonts = with pkgs; [
      terminus_font
      terminus_font_ttf
      symbola
      iosevka
      font-awesome_4
      font-awesome_5
      powerline-fonts
      roboto-mono
      ubuntu_font_family
    ];
  };

  programs.light.enable = true;

  # services.openssh.enable = true;
  services.upower.enable = true;
  services.tlp.enable = true;
  services.transmission.enable = true;

#  systemd.services = {
#    powertop-fixes-script = {
#      enable = true;
#      description = "powertop fixes script";
#      serviceConfig = {
#        requires = [ "powertop.service" ];
#        after = [ "powertop.service" ];
#        ExecStart = "${pkgs.bash}/bin/bash /etc/nixos/power.sh";
#      };
#      wantedBy = [ "multi-user.target" ];
#    };
#  };

#  systemd.services = {
#    kbdd = {
#      enable = true;
#      description = "kbdd";
#      serviceConfig = {
#        Type="simple";
#        ExecStart = "${pkgs.kbdd}/bin/kbdd -n";
#      };
#      wantedBy = [ "multi-user.target" ];
#    };
#  };
 
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "ondemand";
    powertop = {
      enable = true;
    };
  };

  services.actkbd = {
    enable = true;
    bindings = [
      { keys = [ 225 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -A 10"; }
      { keys = [ 224 ]; events = [ "key" ]; command = "/run/current-system/sw/bin/light -U 10"; }
    ];
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  gtk.iconCache.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    desktopManager = {
        default = "none";
        xterm.enable = false;
    };
    displayManager.sessionCommands = ''
#                                     kbdd
#                                     setxkbmap -layout us,ru -option "grp:alt_space_toggle"
                                     '';
    displayManager.lightdm.greeters.mini = {
        enable = true;
        user = "pwnst";
        extraConfig = ''
            [greeter]
            show-password-label = false
            [greeter-theme]
            font = Iosevka
            error-color = "#89E7FB"
            background-color =  "#333645"
            window-color = "#E771B6"
            password-background-color = "#333645"
            password-color = "#89E7FB"
            border-width = 1px
            border-color = "#E771B6"
            layout-space = 2
        '';
    };
    windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
            dmenu
            i3status
            i3blocks-gaps
            i3lock
        ];
    };
  };

  users.users.pwnst = {
    isNormalUser = true;
    home="/home/pwnst";
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "19.03";
}

