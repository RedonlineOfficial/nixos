{ self, inputs, ... }: {
  flake.nixosModules."common" = { ... }: {
    imports = [
      self.nixosModules."common-homeManager"
    ];
  };
}
