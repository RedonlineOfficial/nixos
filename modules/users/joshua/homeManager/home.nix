{ self, inputs, ... }: {
  flake.homeModules."user-joshua" = { ... }: {
    home = {
      username = "joshua";
      homeDirectory = "/home/joshua";
      stateVersion = "26.05";
    };

    programs.home-manager.enable = true;
    programs.zsh.enable = true;
  };
}
