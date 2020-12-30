{ pkgs, ... } :

{
  services.xserver = {
    enable = true;
    autorun = true;
    #    exportConfiguration = true;

    desktopManager = { xterm.enable = false; };

    displayManager = {
      #      startx.enable = true;
      defaultSession = "none+i3";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [ dmenu i3status ];
    };
  };
}
