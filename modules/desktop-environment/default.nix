{ pkgs, ...}:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # Configure keymap in X11
    layout = "us, gr";
    xkbOptions = "grp:alt_shift_toggle";
    displayManager = {
      sddm = {
        enable = true;
      };
    };
  };
  # console.useXkbConfig = true;
}
