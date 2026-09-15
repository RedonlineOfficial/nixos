{ self, inputs, ... }: {
  flake.nixosModules."user-joshua" = { pkgs, ... }: {
    users.users."joshua" = {
      description = "Joshua Myers";
      name = "joshua";
      createHome = true;
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "changeme";
      home = "/home/joshua";
      shell = pkgs.zsh;
    };

    home-manager.users."joshua" = self.homeModules."user-joshua";
  };
}

