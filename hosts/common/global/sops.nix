{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/angelos/.config/sops/age/keys.txt";
    secrets.example-key = { };
    secrets."myservice/my_subdir/my_secret" = {
      owner = "sometestservice";
    };
  };
}
