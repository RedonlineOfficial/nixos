{ self, inputs, ... }: {
  flake.homeConfigurations."joshua" = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    modules = [ 
      self.homeModules."user-joshua"
      self.homeModules."user-joshua-zshAliases"
    ];
  };
}
