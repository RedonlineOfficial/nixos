{ self, inputs, ... }: {
  flake.nixosConfigurations."site1-ws-nix-01" = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      inputs.disko.nixosModules.disko
      self.nixosModules.disko_efi-2disk-luks-split-home
      self.nixosModules."site1-ws-nix-01"
      ./_hardware-configuration.nix
      self.nixosModules."user-joshua"
    ];
  };
}
