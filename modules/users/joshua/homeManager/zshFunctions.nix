{ self, inputs, ... }: {
  flake.homeModules."user-joshua-zshFunctions" = { ... }: {
    programs.zsh.initContent = /* zsh */ ''
      # --- General Functions --------------------------------------------------
      ### Navigation

      # Moves up the specified amount of directories with 'up N' where N is the amount of directories
      moveDirUp() {     		
        local levels="''${1:-1}"
        local destination

        case "$levels" in
          ""|*[!0-9]*)
            printf 'Usage: up [positive-integer]\n' >&2
            return 2
            ;;
        esac

        while [[ "$levels" -gt 0 ]]; do
          destination="../''${destination}"
          levels=''$((levels - 1))
        done

        cd -- "$destination"
      }

      ### Directory and File Manipulation

      # Make new directories and immediately move into them
      mkdirAndCd() {
        if [[ -z "$1" ]]; then
          printf 'Usage: mkcd <path/file_name>' >&2
          return 2
        fi

        mkdir -pv $1 && cd $1
      }

      # Universal file extraction tool.  Adds nix compatibility by temporarily installing the required compression program without needing it installed.
      extract() {
        local file
        local -a fileUnknown
        local -a fileNotFound
        if [[ -z "$1" ]]; then
          echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
          echo "       ex <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
          return 1
        else
          for file in $@
          do
            if [[ -f "$file" ]]; then
              case "''${file%}" in
                *.tar.bz2|*.tbz2)
                  nix shell nixpkgs#gnutar nixpkgs#bzip2 -c tar xvjf "$file" ;;
                *.tar.gz|*.tgz)
                  nix shell nixpkgs#gnutar nixpkgs#gzip -c tar xvzf "$file" ;;
                *.tar.xz|*.txz)
                  nix shell nixpkgs#gnutar nixpkgs#xz -c tar xvJf "$file" ;;
                *.tar.zst|*.tzst)
                  nix shell nixpkgs#gnutar nixpkgs#zstd -c tar --zstd xvf "$file" ;;
                *.tar)
                  nix shell nixpkgs#gnutar -c tar xvf "$file" ;;
                *.zip)
                  nix shell nixpkgs#unzip -c unzip "$file" ;;
                *.rar)
                  nix shell nixpkgs#unrar -c unrar x "$file" ;;
                *.7z)
                  nix shell nixpkgs#p7zip -c 7z x "$file" ;;
                *.gz)
                  nix shell nixpkgs#gzip -c gunzip -k "$file" ;;
                *.bz2)
                  nix shell nixpkgs#bzip2 -c bunzip2 -k "$file" ;;
                *.xz)
                  nix shell nixpkgs#xz -c unxz -k "$file" ;;
                *.zst)
                  nix shell nixpkgs#zstd -c unzstd "$file" ;;
                *.Z)
                  nix shell nixpkgs#gzip -c uncompress "$file" ;;
                *)
                  echo "ex: '$file' - Unsure how to extract. Skipping..."
                  fileUnknown+=("$file")
                  continue
                  ;;
              esac
            else
              echo "ex: '$file' - File does not exist."
              fileNotFound+=("$file")
              continue
            fi
          done
        fi

        if (( ''${#fileNotFound[@]} > 0 )); then
          echo "The following files were not found."
          printf '  %s\n' "''${fileNotFound[@]}"
        fi
        
        if (( ''${#fileUnknown[@]} > 0 )); then
          echo "The following files were skipped due to an unknown file extension:"
          printf '  %s\n' "''${fileUnknown[@]}"
        fi
      }

      
      # --- NixOS Functions --------------------------------------------------
      # NixOS System Management

      # Calls the 'nixos-rebuild switch' command. Defaults to main system configuration directory and hostname, but allows edits.  Uses $HOSTNAME for forward compatability with multi-host configs
      nixosSwitch() {
        local flakeRoot="''${1:-/home/joshua/nixos}"
        local hostname="''${2:$HOSTNAME}"

        sudo nixos-rebuild switch --flake "''${flakeRoot}#''${hostname}"
      }

      # Same as nixosSwitch(), but updates the lock file first
      nixosSwitchUpdate() {
        local flakeRoot="''${1:-/home/joshua/nixos}"
        local hostname="''${2:$HOSTNAME}"

        nix flake update
        sudo nixos-rebuild switch --flake "''${flakeRoot}#''${hostname}"
      }

      # Same as nixosSwitch but for home-manager
      homeManagerSwitch() {
        local flakeRoot="''${1:-/home/joshua/nixos}"
        local username="''${2:-$USER}"

        home-manager switch --flake "''${flakeRoot}#''${username}"
      }

      # Allows easy editing of the nixos configuration from anywhere.  Takes note of the current directory, CD to nixos's root directory and enters neovim's file explorer. When neovim exits, CD to original directory
      editNixConfig() {
        local flakeRoot="''${1:-/home/joshua/nixos}"
        local currentDir="$PWD"
        cd "$flakeRoot" && nvim .
        cd "$currentDir"
      }

      # This bypasses the neovim splash screen when called with no arguments, instead entering the file explorer of the current directory.
      nvimOrDir() {
        nvim "''${1:-.}"
      };

      # --- Diagnostic Functions -----------------------------------------------
      # Services
      
      # Pulls up the systemctl status of a service
      serviceStatus() {
      	if [[ -z "$1" ]]; then
          printf 'Usage: svcstatus <service>\n' >&2
          return 2
        fi

        systemctl status "$@"
      }

      # Opens the journalctl logs of a service
      serviceLogs() {
      if [[ "$#" -lt 1 ]]; then
        printf 'Usage: svclogs <service> [journalctl-options]\n' >&2
        return 2
      fi

      local service="$1"
      shift
      journalctl -u "$service" "$@"
      }
    '';
  };
}
