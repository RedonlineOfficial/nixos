{ self, inputs, ... }: {
  flake.nixosModules."disko_efi-2disk-luks-split-home" = { config, lib, ... }: { 
    disko.devices = {
      disk = {
        main = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-SAMSUNG_MZAL41T0HBLB-00BL2_S67KNF0T652018";
          content = {
            type = "gpt";
            partitions = {
              ESP = {
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };  
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "cryptroot";
                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/";
                  };
                };
              };
            };
          };
        };

        home = {
          type = "disk";
          device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_1TB_S59ANS0N816318R";
          content = {
            type = "gpt";
            partitions = {
              luks = {
                size = "100%";
                content = {
                  type = "luks";
                  name = "crypthome";
                  settings = {
                    allowDiscards = true;
                    bypassWorkqueues = true;
                  };
                  content = {
                    type = "filesystem";
                    format = "ext4";
                    mountpoint = "/home";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
