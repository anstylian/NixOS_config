
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.angelos = {
    isNormalUser = true;
    home = "/home/angelos";
    description = "angelos";
    extraGroups = [ "wheel" "docker" ];
  };
}
