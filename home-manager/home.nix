{ pkgs, lib, ... }:

{
  home.file.".xneur/xneurrc".text = ''
    LogLevel Trace
  '';
  home.file.".i3blocks.conf".text = ''
    [audio]
    interval=once
    command=~/config/scripts/audio1.sh
    signal=10

    [wifi]
    label=
    command=~/config/scripts/network1.sh
    interval=10

    #[battery]
    #command=~/config/scripts/battery.py
    #markup=pango
    #interval=30

    [battery-plus]
    command=~/config/scripts/battery-plus
    markup=pango
    instance=BAT0
    interval=30

    #[kbdd_layout]
    #command=~/config/scripts/kbdd_layout
    #interval=persist

    [keymap]
    label=
    #command=xkb-switch -W
    #or
    command=bash -c 'xkb-switch;xkb-switch -W'
    interval=persist
    #border=#0d5eaf

    [time]
    command= date '+%d/%m/%Y   %H:%M '
    label= 
    interval=1
  '';

  xsession.windowManager.i3 = {
    enable = true;
    config = let
      mod = "Mod4";
      ws1 = "1 ";
      ws2 = "2 ";
      ws3 = "3 ";
      ws4 = "4 ";
      ws5 = "5 ";
      ws6 = "6";
      ws7 = "7";
      ws8 = "8";
      ws9 = "9";
      ws10 = "10";
    in {
      modifier = mod;
      gaps.inner = 5;
      window.commands = [
        { command = "border pixel 0"; criteria = { class = ".*"; }; }
      ];
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec i3-sensible-terminal";
        "${mod}+Shift+q" = "kill";
        "${mod}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run  -fn 'DejaVu Sans Mono-12' -nb '#555555'";

        "${mod}+j" = "focus left";
        "${mod}+k" = "focus down";
        "${mod}+l" = "focus up";
        "${mod}+semicolon" = "focus right";

        "${mod}+Shift+j" = "move left";
        "${mod}+Shift+k" = "move down";
        "${mod}+Shift+l" = "move up";
        "${mod}+Shift+semicolon" = "move right";

        "${mod}+h" = "split h";
        "${mod}+v" = "split v";

        "${mod}+f" = "fullscreen toggle";
        
        "${mod}+s" = "layout stacking";
        "${mod}+w" = "layout tabbed";
        "${mod}+e" = "layout toggke split";
        
        "${mod}+Shitf+space" = "floating toggle";
        "${mod}+space" = "focut toggle";

        "${mod}+1" = "workspace ${ws1}";
        "${mod}+2" = "workspace ${ws2}";
        "${mod}+3" = "workspace ${ws3}";
        "${mod}+4" = "workspace ${ws4}";
        "${mod}+5" = "workspace ${ws5}";
        "${mod}+6" = "workspace ${ws6}";
        "${mod}+7" = "workspace ${ws7}";
        "${mod}+8" = "workspace ${ws8}";
        "${mod}+9" = "workspace ${ws9}";
        "${mod}+0" = "workspace ${ws10}";

        "${mod}+Shift+1" = "move container to workspace ${ws1}";
        "${mod}+Shift+2" = "move container to workspace ${ws2}";
        "${mod}+Shift+3" = "move container to workspace ${ws3}";
        "${mod}+Shift+4" = "move container to workspace ${ws4}";
        "${mod}+Shift+5" = "move container to workspace ${ws5}";
        "${mod}+Shift+6" = "move container to workspace ${ws6}";
        "${mod}+Shift+7" = "move container to workspace ${ws7}";
        "${mod}+Shift+8" = "move container to workspace ${ws8}";
        "${mod}+Shift+9" = "move container to workspace ${ws9}";
        "${mod}+Shift+0" = "move container to workspace ${ws10}";

        "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5% && pkill -RTMIN+10 i3blocks";
        "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5% && pkill -RTMIN+10 i3blocks";
        "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle && pkill -RTMIN+10 i3blocks";
        
        "XF86MonBrightnessUp" = "exec xbacklight -inc 20";
        "XF86MonBrightnessDown" = "exec xbacklight -dec 20";

        "XF86AudioPlay" = "exec playerctl play";
        "XF86AudioPause" = "exec playerctl pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
      };
      

      modes = {
        resize = {
          j = "resize shrink width 10 px or 10 ppt";
          l = "resize grow height 10 px or 10 ppt";
          k = "resize shrink height 10 px or 10 ppt";
          semicolon = "resize grow width 10 px or 10 ppt";
          Return = "mode default";
          Escape = "mode default";
        };
      };
      
      assigns = {
        "${ws2}" = [
          { class = "Firefox"; }
        ];
        "${ws5}" = [
          { class = "TelegramDesktop"; }
        ];
      };

      bars = [
        {
          statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
          position = "top";
          fonts = [
            "DejaVu Sans Mono"
            "FontAwesome 12"
          ];
          colors = {
            background = "#555555";
            statusline = "#dddddd";
            separator = "#666666";
            focusedWorkspace = {
              background = "#0088CC";
              border = "#0088CC";
              text = "#ffffff";
            };
            activeWorkspace = {
              background = "#333333";
              border = "#333333";
              text = "#ffffff";
            };
            inactiveWorkspace = {
              background = "#333333";
              border = "#333333";
              text = "#888888";
            };
            urgentWorkspace = {
              background = "#2f343a";
              border = "#900000";
              text = "#ffffff";
            };
          };
        }
      ];

      startup = [
          { command = "setxkbmap -layout us,ru -option 'grp:alt_space_toggle'"; notification = false; always = true; }
          { command = "feh --bg-scale /home/pwnst/Pictures/kFLGAsV.png"; notification = false; always = true; }
      ];
    };
  };

  programs.termite = {
    enable = true;
    font = "Iosevka";
    colorsExtra = ''
      highlight = #2f2f2f
      color0 = #3f3f3f
      color1 = #705050
      color2 = #60b48a
      color3 = #dfaf8f
      color4 = #506070
      color5 = #dc8cc3
      color6 = #8cd0d3
      color7 = #dcdccc
      color8 = #709080
      color9 = #dca3a3
      color10 = #c3bf9f
      color11 = #f0dfaf
      color12 = #94bff3
      color13 = #ec93d3
      color14 = #93e0e3
      color15 = #ffffff
    '';
  };

  programs.git = {
    enable = true;
    userName = "Aleksey Tretyak";
    userEmail = "aleksey.tretyak@gmail.com";
  };
  
  programs.vim = {
    enable = true;
    extraConfig = ''
      filetype plugin indent on
      set tabstop=4
      set shiftwidth=4
      set expandtab
      syntax on
    '';
  };
}

