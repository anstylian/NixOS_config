{ pkgs, ...}:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us";
    displayManager = {
      sddm = {
        enable = true;
      };
    };
  };
}
