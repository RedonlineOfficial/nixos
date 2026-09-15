{ self, inputs, ... }: {
  flake.homeModules."user-joshua-zshAliases" = { ... }: {
    imports = [ self.homeModules."user-joshua-zshFunctions" ];
    programs.zsh.shellAliases = {
      # --- General Aliases ----------------------------------------------------
      # Shell
      reload = "exec $SHELL -L";    # Reloads the shell in-place

      # Navigation
      up = "moveDirUp";
      ".." = "cd ..";
      
      # Safety Overlays
      cp = "cp -ri";                                # Adds -i and -r flag to cp command. -i requires user confirmation on copy operations that would overright other files, -r allows copying directories recurrsively.
      mv = "mv -i";     				                    # Adds -i flag to mv command. -i requires user confirmation on moves resulting in overwriting files.
      rm = "mv --force -t ~/.local/share/Trash ";   # Replaces original rm command with a move command that sends files to the system trash instead of permenatly deleting them.

      # Directory/File Manipulation
      mkd = "mkdir -pv";      # -p creates parent directories recursively, -v prints directories created.
      mkcd = "mkdirAndCD";    # Creates a directory (mkdir -pv to allow resurive directory creation) and CD into new directory (see zshFunctions.nix).
      rmd = "rmdir";          # rmdir removes empty directories. 
      rmp = "rm -ri";         # Standard rm command with -r (allows directory removal) and -i (forces user confirmation before file deletion)
      ex = "extract";         # Automatically determines what program and flag is required to decompress a file.  Temporarily installs required packages with 'nix shell nixpkgs#<pkg>'.

      # --- NixOS Aliases ------------------------------------------------------ 
      # NixOS System Management
      nxs = "nixosSwitch";                                                      # Uses function `nixosSwitch` to rebuild the nixos configuration (see zshFunctions.nix)
      nxsu = "nixSwitchUpdate";                                                 # Updates lock file then switches
      nxsr = "sudo nixos-rebuild switch --flake . --rollback";                  # Roll back to previous generation
      nxgens = "nix profile history --profile /nix/var/nix/profiles/system";    # List system generations
      hms = "homeManagerSwitch";                                                # Uses function `homeManagerSwitch` to rebuild the home-manager configuration (see zshFunctions.nix)
      hmn = "home-manager news";                                            	# Shows home-manager chnagelog
      hmgens = "home-manager generations";                                      # List Home Manager generations
      nxc = "editNixConfig";                                                    # CD to configuration directory and opens $EDITOR then CD back to previous directory

      # NixOS Flake Maintenance
      nfc = "nix flake check";          # Checks flake for evaluation errors
      nfu = "nix flake update";         # Updates all inputs
      nfl = "nix flake lock";           # Relock flake.lock without updating
      nfs = "nix flake show";           # Show flake outputs
      nfm = "nix flake metadata";       # Show flake metadata / input revisions

      # Nixos Garbage Collection 
      ngc = "sudo nix-sweep cleanout --remove-older 7 --keep-min 10 system user home";      # Uses nix-sweep as a interface to nix-collect-garbage.  Allows specifying the amount of generations to keep rather than by date.
      nsr = "sudo nix-store --verify --check-contents --repair";                            # Verify and repair the nix store
      nso = "sudo nix-store --optimise";                                                    # Deduplicates the nix store via hardlinks 

      # --- Diagnostic Aliases -------------------------------------------------
      # Network
      extip = "wget -qO- https://api.ipify.org";    # Gets the hosts external IP from ipify.org (this is typically the router's ip address unless host is exposed to the internet
      locip = "hostname -I";                        # Gets the hosts internal IP.   This is the IP the host has from the router.
      pcf = "ping -c 5 1.1.1.1";                    # Pings cloudflare's DNS IP 5 times.  Useful for quick network check.
      pcfc = "ping 1.1.1.1";                        # Pings cloudflare's DNS IP continously until stopped.  Useful to check when internet access returns.
      svcstatus = "serviceStatus";                  # Checks the status of a service with systemctl (see zshFunctions.nix)
      svclogs = "serviceLogs";                      # Checks the logs of a service with journalctl (see zshFunctions.nix


      # --- Program Specific Aliases -------------------------------------------
      # Git
      gi = ''git init && git commit --allow-empty -m "chore: init" && git tag v0.0.0'';   # Initialize a directory, create init commit, and tag as v0.0.0
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -v";
      gca = "git commit -v --amend";                                                      # Like a normal git commit, but amends the last commit.
      gp = "git push --tags";                                                             # Push all commits with their tags.
      gpl = "git pull";
      gcl = "git clone";
      gd = "git diff";
      gl = "git log --color=always --pretty=format:'%C(red)%h%C(reset) %C(yellow)%ad%C(reset) %C(green)(%ar)%C(reset)%C(auto)%d%C(reset) %C(white)%s%C(reset)' --date=format:'%d %b %Y %H:%M' | sed 's/tag: //g'";
      gll = "git log --color=always --pretty=format:'%C(red)%h%C(reset) %C(yellow)%ad%C(reset) %C(green)(%ar)%C(reset)%C(auto)%d%C(reset) %C(white)%s%C(reset)' --date=format:'%d %b %Y %H:%M' | sed 's/tag: //g' | less -R";
      grs = "git restore --staged";                                                       # Removes a file from being staged.  Useful for nix configs when rebuilds require all files to be tracked.

      # Neovim
      v = "nvimOrDir";	       # I don't see a use in the neovim splash screen when using 'nvim' without a file path.  This will open a filepath as normal, or if no file path, perform 'nvim .' to open the file explorer.	
      sv = "sudo nvimOrDir";   # Same as above, but with sudo
    };
  };
}
