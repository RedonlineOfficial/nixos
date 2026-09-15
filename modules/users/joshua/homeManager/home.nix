{ self, inputs, ... }: {
  flake.homeModules."user-joshua" = { ... }: {
    home = {
      username = "joshua";
      homeDirectory = "/home/joshua";
      stateVersion = "26.05";
    };

    programs.zsh.enable = true;
  };
}
