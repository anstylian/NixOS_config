{ pkgs, ...}:

{
  # Enable the X11 windowing system.
  services.xserver = {
    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };
}
